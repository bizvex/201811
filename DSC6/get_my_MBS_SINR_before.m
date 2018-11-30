function [ UE_MBS_SINR_before ] = get_my_MBS_SINR_before(config,UE)

for u_ = 1:length(UE)
    UE(u_).get_MBS_SINR_before(config);
end

UE_MBS_SINR_before = [UE.MBS_SINR_before];

end