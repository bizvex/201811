function [ biCentSet, UE_belong2_UAV, point2center ] = binKMeans( dataSet, k, UE2MBS, MBS)

[row,col] = size(dataSet);
% 存储质心矩阵
biCentSet = zeros(k,col);
% 初始化设定cluster数量为1
numCluster = 1;
%第一列存储每个点被分配的质心，第二列存储点到质心的距离
biClusterAssume = zeros(row,3);
%初始化质心
biCentSet(1,:) = mean(dataSet);
for i = 1:row
    [dist] = distEclud(dataSet(i,:),biCentSet(1,:));
    biClusterAssume(i,1) = numCluster;% 不含0
    biClusterAssume(i,2) = dist;
    biClusterAssume(i,3) = numCluster;% 含0 use
end

while numCluster < k
    minSSE = inf;
    %寻找对哪个cluster进行划分最好，也就是寻找SSE最小的那个cluster
    for j = 1:numCluster
        index = find(biClusterAssume(:,1) == j);
        curCluster = dataSet(index,:);
        UE2MBSCluster = UE2MBS(index);
        loop = true;
        count = 0;
        while loop
            [spiltCentSet,spiltClusterAssume] = kMeans(curCluster,2, UE2MBSCluster);
            loop = false;
            for g = 1:size(spiltCentSet,1)
                if isnan(spiltCentSet(g,1)) || isnan(spiltCentSet(g,2))
                    loop = true;
                    break;
                end
            end
            count = count+1;
            if count>100
                loop = false;
                spiltCentSet = [0 0;0 0];
                spiltClusterAssume = [0 inf 0];
            end
        end
        spiltSSE = sum(spiltClusterAssume(:,2));
        noSpiltSSE = sum(biClusterAssume(find(biClusterAssume(:,1)~=j),2));
        curSSE = spiltSSE + noSpiltSSE;
        
%         fprintf('第%d个cluster被划分后的误差为：%f \n' , [j, curSSE]);

        if (curSSE < minSSE)% 拿一个使总体小的去裂
            minSSE = curSSE;
            bestClusterToSpilt = j;
            bestClusterAssume = spiltClusterAssume;
            bestCentSet = spiltCentSet;
        end
    end

     %更新cluster的数目  
    numCluster = numCluster + 1;
    % 必须先更新2的为新的类，再更新1的为原来的类，不然的话，当对第二个cluster进行划分的时候，就会被全部分为同一个类
    bestClusterAssume(find(bestClusterAssume(:,1) == 2),1) = numCluster;
    bestClusterAssume(find(bestClusterAssume(:,1) == 1),1) = bestClusterToSpilt;
    bestClusterAssume(find(bestClusterAssume(:,3) == 2),3) = numCluster;
    bestClusterAssume(find(bestClusterAssume(:,3) == 1),3) = bestClusterToSpilt;

    
    % 更新和添加质心坐标  第一行为更新质心，第二行为添加质心
    biCentSet(bestClusterToSpilt,:) = bestCentSet(1,:);
    biCentSet(numCluster,:) = bestCentSet(2,:);

    % 更新被划分的cluster的每个点的质心分配以及误差
    biClusterAssume(find(biClusterAssume(:,1) == bestClusterToSpilt),:) = bestClusterAssume;
end

point2center = biClusterAssume(:,2);% 包含了UE到MBS和UE到UAV的距离

% 找到每个UAV能够服务的UE
UE_belong2_UAV = cell(1,k);
for i = 1:k
    UE_belong2_UAV{i} = find(biClusterAssume(:,3) == i);
end

figure
%scatter(dataSet(:,1),dataSet(:,2),5)
for i = 0:k
    pointCluster = find(biClusterAssume(:,3) == i);
    scatter(dataSet(pointCluster,1),dataSet(pointCluster,2),5)
    hold on
end
%hold on
scatter(biCentSet(:,1),biCentSet(:,2),300,'+')
hold off
biCentSet

end

% 计算欧式距离
function [dist] = distEclud(vecA,vecB)
    dist = sqrt(sum(power((vecA-vecB),2)));
end

% K-means算法
function [centSet,clusterAssment] = kMeans(dataSet,K,UE2MBS)

[row,col] = size(dataSet);
% 存储质心矩阵
centSet = zeros(K,col);
% 随机初始化质心
for i= 1:col
    minV = min(dataSet(:,i));
    if isempty(minV)
        break;
    end
    rangV = max(dataSet(:,i)) - minV;
    centSet(:,i) = bsxfun(@plus,minV,rangV*rand(K,1));
end

% 用于存储每个点被分配的cluster以及到质心的距离
clusterAssment = zeros(row,3);
clusterChange = true;
count = 0;
while clusterChange
    clusterChange = false;
    % 计算每个点应该被分配的cluster
    for i = 1:row
        dist2MBS = UE2MBS(i);
        mindist = inf;
        minIndex = 0;
        minIndex2 = 0;
        compare = inf;
        for j = 1:K
            [distCal] = distEclud(dataSet(i,:) , centSet(j,:));
            if (distCal < compare)
                compare = distCal;
                minIndex = j;
            end
            if (distCal < dist2MBS)
                if (distCal < mindist)
                    mindist = distCal;
                    minIndex2 = j;
                end
            else
                if (mindist > dist2MBS)
                    mindist = dist2MBS;
                    minIndex2 = 0;
                    
                end
            end
        end
        if minIndex2 ~= clusterAssment(i,3)            
            clusterChange = true;% 当任意一个点所属的簇分配结果发生改变时
        end
        clusterAssment(i,1) = minIndex;
        clusterAssment(i,2) = mindist;
        clusterAssment(i,3) = minIndex2;
    end
    
    % 更新每个cluster 的质心
    for j = 1:K
        % 如果没有任何一个UE离UAV1比较近就会陷入死循环
        % 用clusterAssment(:,1) == j可以避免
        % 但是这样就不能将UAV放置在UAV服务的UE簇的中心
        % 可以重新跑,但是重新跑如果dataSet数目很小也不能避免死循环，那就不裂这个cluster了
        % 还有个问题，可能没法收敛
        simpleCluster = find(clusterAssment(:,3) == j);
        centSet(j,:) = mean(dataSet(simpleCluster',:));
        if isnan(centSet(j,1)) || isnan(centSet(j,2))
            clusterChange = false;% 一旦出现NaN就跳出，重新跑过
            break;
        end
    end
    
    count = count+1;
    if count>100
        clusterChange = false;% 一旦没法收敛，就选一个跳出
    end
end

end

