function [ biCentSet, UE_belong2_UAV, point2center ] = kMeans(dataSet, K, UE2MBS)

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
        simpleCluster = find(clusterAssment(:,3) == j);
        centSet(j,:) = mean(dataSet(simpleCluster',:));
    end
    
    figure;
    for i = 0:K
        pointCluster = find(clusterAssment(:,3) == i);
        scatter(dataSet(pointCluster,1),dataSet(pointCluster,2),5)
        hold on
    end
    %hold on
    scatter(centSet(:,1),centSet(:,2),300,'+')
    hold off
    centSet
end

biCentSet = centSet;
point2center = clusterAssment(:,2);% 包含了UE到MBS和UE到UAV的距离
% 找到每个UAV能够服务的UE
UE_belong2_UAV = cell(1,K);
for i = 1:K
    UE_belong2_UAV{i} = find(clusterAssment(:,3) == i);
end

% figure
% %scatter(dataSet(:,1),dataSet(:,2),5)
% for i = 0:K
%     pointCluster = find(clusterAssment(:,3) == i);
%     scatter(dataSet(pointCluster,1),dataSet(pointCluster,2),5)
%     hold on
% end
% %hold on
% scatter(biCentSet(:,1),biCentSet(:,2),300,'+')
% hold off
% biCentSet

end

function [dist] = distEclud(vecA,vecB)
    dist = sqrt(sum(power((vecA-vecB),2)));
end