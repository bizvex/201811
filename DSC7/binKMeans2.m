function [ biCentSet, UE_belong2_UAV, point2center  ] = binKMeans2( dataSet, k)

[row,col] = size(dataSet);
% 存储质心矩阵
biCentSet = zeros(k,col);
% 初始化设定cluster数量为1
numCluster = 1;
%第一列存储每个点被分配的质心，第二列存储点到质心的距离
biClusterAssume = zeros(row,2);
%初始化质心
biCentSet(1,:) = mean(dataSet);
for i = 1:row
    biClusterAssume(i,1) = numCluster;
    biClusterAssume(i,2) = distEclud(dataSet(i,:),biCentSet(1,:));
end
while numCluster < k
    minSSE = inf;
    %寻找对哪个cluster进行划分最好，也就是寻找SSE最小的那个cluster
    for j = 1:numCluster
        curCluster = dataSet(find(biClusterAssume(:,1) == j),:);
        
        loop = true;
        count = 0;
        while loop
            [spiltCentSet,spiltClusterAssume] = kMeans(curCluster,2);%对簇j进行分裂成两个簇
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
        spiltSSE = sum(spiltClusterAssume(:,2));%求簇j分裂成两个簇后，簇j的SSE
        noSpiltSSE = sum(biClusterAssume(find(biClusterAssume(:,1)~=j),2));%除簇j外其他簇的SSE
        curSSE = spiltSSE + noSpiltSSE;
        
%         fprintf('第%d个cluster被划分后的误差为：%f \n' , [j, curSSE]);

        if (curSSE < minSSE)
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
    UE_belong2_UAV{i} = find(biClusterAssume(:,1) == i);
end

% figure
% %scatter(dataSet(:,1),dataSet(:,2),5)
% for i = 1:k
%     pointCluster = find(biClusterAssume(:,1) == i);
%     scatter(dataSet(pointCluster,1),dataSet(pointCluster,2),5)
%     hold on
% end
% %hold on
% scatter(biCentSet(:,1),biCentSet(:,2),300,'+')
% hold off
% biCentSet

end

% 计算欧式距离
function dist = distEclud(vecA,vecB)
    dist = sqrt(sum(power((vecA-vecB),2)));
end

% K-means算法
function [centSet,clusterAssment] = kMeans(dataSet,K)

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
clusterAssment = zeros(row,2);
clusterChange = true;
count = 0;
while clusterChange
    clusterChange = false;
    % 计算每个点应该被分配的cluster
    for i = 1:row
        % 这部分可能可以优化
        minDist = inf;
        minIndex = 0;
        for j = 1:K
            distCal = distEclud(dataSet(i,:) , centSet(j,:));
            if (distCal < minDist)
                minDist = distCal;
                minIndex = j;
            end
        end
        if minIndex ~= clusterAssment(i,1)            
            clusterChange = true;
        end
        clusterAssment(i,1) = minIndex;
        clusterAssment(i,2) = minDist;
    end
    
    % 更新每个cluster 的质心
    for j = 1:K
        simpleCluster = find(clusterAssment(:,1) == j);
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

