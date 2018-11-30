function UE_MBS_SINR_after = get_MBS_SINR_after(config,UAV,UE,use_UAV_index)

for u_ = 1:length(UE)
    if ~UE(u_).belong2UAV
        switch config.type
            case 'FFRA'
                UE(u_).get_MBS_SINR_FFRA_after(config);% ��С����UE����SINR
        end
    else
        UE(u_).MBS_SINR_after = -inf;%UAV��UE��MBS SINR
    end
end

UE_MBS_SINR_after = [UE.MBS_SINR_after];

end