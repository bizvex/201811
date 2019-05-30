function [ biCentSet, UE_belong2_UAV, point2center  ] = binKMeans2( dataSet, k)

[row,col] = size(dataSet);
% �洢���ľ���
biCentSet = zeros(k,col);
% ��ʼ���趨cluster����Ϊ1
numCluster = 1;
%��һ�д洢ÿ���㱻��������ģ��ڶ��д洢�㵽���ĵľ���
biClusterAssume = zeros(row,2);
%��ʼ������
biCentSet(1,:) = mean(dataSet);
for i = 1:row
    biClusterAssume(i,1) = numCluster;
    biClusterAssume(i,2) = distEclud(dataSet(i,:),biCentSet(1,:));
end
while numCluster < k
    minSSE = inf;
    %Ѱ�Ҷ��ĸ�cluster���л�����ã�Ҳ����Ѱ��SSE��С���Ǹ�cluster
    for j = 1:numCluster
        curCluster = dataSet(find(biClusterAssume(:,1) == j),:);
        
        loop = true;
        count = 0;
        while loop
            [spiltCentSet,spiltClusterAssume] = kMeans(curCluster,2);%�Դ�j���з��ѳ�������
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
        spiltSSE = sum(spiltClusterAssume(:,2));%���j���ѳ������غ󣬴�j��SSE
        noSpiltSSE = sum(biClusterAssume(find(biClusterAssume(:,1)~=j),2));%����j�������ص�SSE
        curSSE = spiltSSE + noSpiltSSE;
        
%         fprintf('��%d��cluster�����ֺ�����Ϊ��%f \n' , [j, curSSE]);

        if (curSSE < minSSE)
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

% ����ŷʽ����
function dist = distEclud(vecA,vecB)
    dist = sqrt(sum(power((vecA-vecB),2)));
end

% K-means�㷨
function [centSet,clusterAssment] = kMeans(dataSet,K)

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
clusterAssment = zeros(row,2);
clusterChange = true;
count = 0;
while clusterChange
    clusterChange = false;
    % ����ÿ����Ӧ�ñ������cluster
    for i = 1:row
        % �ⲿ�ֿ��ܿ����Ż�
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
    
    % ����ÿ��cluster ������
    for j = 1:K
        simpleCluster = find(clusterAssment(:,1) == j);
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

