function [ biCentSet, UE_belong2_UAV, point2center ] = kMeans(dataSet, K, UE2MBS)

[row,col] = size(dataSet);
% �洢���ľ���
centSet = zeros(K,col);
% �����ʼ������
for i= 1:col
    minV = min(dataSet(:,i));
    if isempty(minV)
        break;
    end
    rangV = max(dataSet(:,i)) - minV;
    centSet(:,i) = bsxfun(@plus,minV,rangV*rand(K,1));
end

% ���ڴ洢ÿ���㱻�����cluster�Լ������ĵľ���
clusterAssment = zeros(row,3);
clusterChange = true;
while clusterChange
    clusterChange = false;
    % ����ÿ����Ӧ�ñ������cluster
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
            clusterChange = true;% ������һ���������Ĵط����������ı�ʱ
        end
        clusterAssment(i,1) = minIndex;
        clusterAssment(i,2) = mindist;
        clusterAssment(i,3) = minIndex2;
    end
    
    % ����ÿ��cluster ������
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
point2center = clusterAssment(:,2);% ������UE��MBS��UE��UAV�ľ���
% �ҵ�ÿ��UAV�ܹ������UE
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