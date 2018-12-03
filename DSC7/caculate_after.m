function [MBS_resource_after,no_serving_after,outage_after,SE_after,SE_all_after,SE_MBS_after,SE_MBS_all_after] = caculate_after( UE_MBS_SINR_after,MBS,UAV,UE )

%% 资源
% after
MBS_resource_after = zeros(1,length(MBS));
no_serving_after = zeros(1,length(MBS));
for b_ = 1:length(MBS)
    MBS_resource = 0;
    attach_UE_vector = MBS(b_).attach_UE_vector;
    UE_resource = [attach_UE_vector.D]./log2(1+10.^(0.1*[attach_UE_vector.MBS_SINR_after]));
    MBS_resource_after(b_) = sum(UE_resource(:));
    num_serving = 0;
    for u_ = 1:length(UE_resource)
        tmp = MBS_resource;
        tmp = tmp + UE_resource(u_);% round robin
        if tmp<=MBS(b_).resource
            MBS_resource = tmp;
            num_serving = num_serving + 1;
        else
            continue;
        end
    end
    num_no_serving = length(UE_resource) - num_serving;
    
    no_serving_after(b_) = num_no_serving;
end
outage_after = sum(no_serving_after(:))/length(UE);% 被UAV服务的都不是outage的
fprintf('outage probability: %f\n',outage_after);

%% SE

% 频谱效率after
UEbelong2UAV = [UE.belong2UAV];
SINR_MBS = UE_MBS_SINR_after((UEbelong2UAV == 0));
SINR_UAV = zeros(1,sum(UEbelong2UAV(:)));
ii = 1;
for d_ = 1:length(UAV)
    if isempty(UAV(d_).attach_UE_vector)
        continue;
    end
    attach_UE_SINR = [UAV(d_).attach_UE_vector.UAV_SINR];
    SINR_UAV(ii:ii+length(attach_UE_SINR)-1) = attach_UE_SINR;
    ii = ii+length(attach_UE_SINR);
end
SE_MBS = log2(1+10.^(0.1.*SINR_MBS));
SE_UAV = log2(1+10.^(0.1.*SINR_UAV));
SE_all_after = [SE_MBS SE_UAV];
SE_all_after=sort(SE_all_after);
SE_MBS_all_after=sort(SE_MBS);

SE_after = sum(SE_all_after(:))/length(UE);
SE_MBS_after = sum(SE_MBS_all_after(:))/length(SE_MBS_all_after);
fprintf('SE after: %f\n',SE_after);
fprintf('SE MBS after: %f\n',SE_MBS_after);
fprintf('5p SE after: %f\n',SE_all_after(ceil(length(SE_all_after)*0.05)));
fprintf('5p SE MBS after: %f\n',SE_MBS_all_after(ceil(length(SE_MBS_all_after)*0.05)));

end

