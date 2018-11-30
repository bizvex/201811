function [MBS_N_after,no_serving_after,outage_after,SE_after,SE_all_after] = caculate_after( config,UE_MBS_SINR_before,UE_MBS_SINR_after,MBS,UAV,UE )

%% 资源
% after
MBS_N_after = zeros(1,length(MBS));
no_serving_after = zeros(1,length(MBS));
for b_ = 1:length(MBS)
    switch config.type
        case {'FFRA','FFRB','FFRD','FFRE'}
            MBS_N = 0;
            attach_UE_vector = MBS(b_).attach_UE_vector;
            UE_N = [attach_UE_vector.D]./log2(1+10.^(0.1*[attach_UE_vector.MBS_SINR_after]));
            MBS_N_after(b_) = sum(UE_N(:));
            num_serving = 0;
            for u_ = 1:length(UE_N)
                tmp = MBS_N;
                tmp = tmp + UE_N(u_);% round robin
                if tmp<=MBS(b_).N_max
                    MBS_N = tmp;
                    num_serving = num_serving + 1;
                else
                    continue;
                end
            end
            num_no_serving = length(UE_N) - num_serving;
    end
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
    if UAV(d_).isUse
        attach_UE_SINR = [UAV(d_).attach_UE_vector.UAV_SINR];
        SINR_UAV(ii:ii+length(attach_UE_SINR)-1) = attach_UE_SINR;
        ii = ii+length(attach_UE_SINR);
    end
end
SE_MBS = log2(1+10.^(0.1.*SINR_MBS));
SE_UAV = log2(1+10.^(0.1.*SINR_UAV));
SE_all_after = [SE_MBS SE_UAV];

SE_after = sum(SE_all_after(:))/length(UE);
fprintf('SE after: %f\n',SE_after);% bps

end

