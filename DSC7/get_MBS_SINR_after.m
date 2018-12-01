function UE_MBS_SINR_after = get_MBS_SINR_after(config,UE)

for u_ = 1:length(UE)
    if ~UE(u_).belong2UAV
        UE(u_).get_MBS_SINR_FFRA_after(config);% 宏小区的UE更新SINR
    else
        UE(u_).MBS_SINR_after = -inf;%UAV的UE的MBS SINR
    end
end

UE_MBS_SINR_after = [UE.MBS_SINR_after];

end