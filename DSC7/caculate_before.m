function [MBS_resource_before,no_serving_before,outage_before,SE_before,SE_all_before] = caculate_before( config,UE_MBS_SINR_before,MBS,UE )

%% 资源
% before
MBS_resource_before = zeros(1,length(MBS));
no_serving_before = zeros(1,length(MBS));
for b_ = 1:length(MBS)
    MBS_resource = 0;
    attach_UE_vector = MBS(b_).attach_UE_vector;
    UE_resource = [attach_UE_vector.D]./log2(1+10.^(0.1*[attach_UE_vector.MBS_SINR_before]));
    MBS_resource_before(b_) = sum(UE_resource(:));
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
    no_serving_before(b_) = num_no_serving;
end
outage_before = sum(no_serving_before(:))/length(UE);
fprintf('outage probability: %f\n',outage_before);


%% SE

% 频谱效率before
SE_all_before = log2(1+10.^(0.1.*UE_MBS_SINR_before));
SE_before = sum(SE_all_before(:))/length(UE_MBS_SINR_before);
fprintf('SE before: %f\n',SE_before);% bps

end

