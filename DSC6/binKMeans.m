function [ biCentSet, UE_belong2_UAV, point2center ] = binKMeans( dataSet, k, UE2MBS, MBS)

[row,col] = size(dataSet);
% �洢���ľ���
biCentSet = zeros(k,col);
% ��ʼ���趨cluster����Ϊ1
numCluster = 1;
%��һ�д洢ÿ���㱻��������ģ��ڶ��д洢�㵽���ĵľ���
biClusterAssume = zeros(row,3);
%��ʼ������
biCentSet(1,:) = mean(dataSet);
for i = 1:row
    [dist] = distEclud(dataSet(i,:),biCentSet(1,:));
    biClusterAssume(i,1) = numCluster;% ����0
    biClusterAssume(i,2) = dist;
    biClusterAssume(i,3) = numCluster;% ��0 use
end

while numCluster < k
    minSSE = inf;
    %Ѱ�Ҷ��ĸ�cluster���л�����ã�Ҳ����Ѱ��SSE��С���Ǹ�cluster
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
        
%         fprintf('��%d��cluster�����ֺ�����Ϊ��%f \n' , [j, curSSE]);

        if (curSSE < minSSE)% ��һ��ʹ����С��ȥ��
            minSSE = curSSE;
            bestClusterToSpilt = j;
            bestClusterAssume = spiltClusterAssume;
            bestCentSet = spiltCentSet;
        end
    end

     %����cluster����Ŀ  
    numCluster = numCluster + 1;
    % �����ȸ���2��Ϊ�µ��࣬�ٸ���1��Ϊԭ�����࣬��Ȼ�Ļ������Եڶ���cluster���л��ֵ�ʱ�򣬾ͻᱻȫ����Ϊͬһ����
    bestClusterAssume(find(bestClusterAssume(:,1) == 2),1) = numCluster;
    bestClusterAssume(find(bestClusterAssume(:,1) == 1),1) = bestClusterToSpilt;
    bestClusterAssume(find(bestClusterAssume(:,3) == 2),3) = numCluster;
    bestClusterAssume(find(bestClusterAssume(:,3) == 1),3) = bestClusterToSpilt;

    
    % ���º������������  ��һ��Ϊ�������ģ��ڶ���Ϊ�������
    biCentSet(bestClusterToSpilt,:) = bestCentSet(1,:);
    biCentSet(numCluster,:) = bestCentSet(2,:);

    % ���±����ֵ�cluster��ÿ��������ķ����Լ����
    biClusterAssume(find(biClusterAssume(:,1) == bestClusterToSpilt),:) = bestClusterAssume;
end

point2center = biClusterAssume(:,2);% ������UE��MBS��UE��UAV�ľ���

% �ҵ�ÿ��UAV�ܹ������UE
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

% ����ŷʽ����
function [dist] = distEclud(vecA,vecB)
    dist = sqrt(sum(power((vecA-vecB),2)));
end

% K-means�㷨
function [centSet,clusterAssment] = kMeans(dataSet,K,UE2MBS)

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
count = 0;
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
        % ���û���κ�һ��UE��UAV1�ȽϽ��ͻ�������ѭ��
        % ��clusterAssment(:,1) == j���Ա���
        % ���������Ͳ��ܽ�UAV������UAV�����UE�ص�����
        % ����������,�������������dataSet��Ŀ��СҲ���ܱ�����ѭ�����ǾͲ������cluster��
        % ���и����⣬����û������
        simpleCluster = find(clusterAssment(:,3) == j);
        centSet(j,:) = mean(dataSet(simpleCluster',:));
        if isnan(centSet(j,1)) || isnan(centSet(j,2))
            clusterChange = false;% һ������NaN�������������ܹ�
            break;
        end
    end
    
    count = count+1;
    if count>100
        clusterChange = false;% һ��û����������ѡһ������
    end
end

end

