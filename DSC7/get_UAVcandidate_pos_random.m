function [ UAVcandidate_pos,UAVcandidateUE, UE2UAVcandidate ] = get_UAVcandidate_pos_random( config,UE_pos,UE )
UE2MBS=[UE.this2MBS];
ISD = config.ISD;
MBS_r = ISD/2/sqrt(3)*2;
map_r = MBS_r+ISD;
UAVcandidate_pos = spatial_in_circle(map_r,config.n_UAV,[0,0]);

biClusterAssume = zeros(size(UE_pos,1),3);
for u_ = 1:size(UE_pos,1)
    dist = inf;
    for d_ = 1:size(UAVcandidate_pos,1)
        disttmp = distEclud(UE_pos(u_,:),UAVcandidate_pos(d_,:));
        if disttmp<UE2MBS(u_)
            if disttmp<dist
                dist = disttmp;
                biClusterAssume(u_,:) = [d_,dist,d_];
            end
        else
            if disttmp<dist
                dist = disttmp;
                biClusterAssume(u_,:) = [d_,dist,0];
            end
        end
    end
end

UAVcandidateUE = cell(1,size(UAVcandidate_pos,1));
for d_ = 1:size(UAVcandidate_pos,1)
    UAVcandidateUE{d_} = find(biClusterAssume(:,3) == d_);
end
UE2UAVcandidate = biClusterAssume(:,2);% 包含了UE到MBS和UE到UAV的距离

% figure
% %scatter(dataSet(:,1),dataSet(:,2),5)
% for i = 0:config.n_UAVcandidate
%     pointCluster = find(biClusterAssume(:,3) == i);
%     scatter(UE_pos(pointCluster,1),UE_pos(pointCluster,2),5)
%     hold on
% end
% %hold on
% scatter(UAVcandidate_pos(:,1),UAVcandidate_pos(:,2),300,'+')
% hold off
% UAVcandidate_pos

end

function [dist] = distEclud(vecA,vecB)
    dist = sqrt(sum(power((vecA-vecB),2)));
end

