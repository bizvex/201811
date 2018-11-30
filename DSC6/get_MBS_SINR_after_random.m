function UE_MBS_SINR_after = get_MBS_SINR_after_random(config,UAV,UE,use_UAV_index)

for u_ = 1:length(UE)
    if ~UE(u_).belong2UAV
        Pr_vector = zeros(1,length(use_UAV_index));
        for d_ = 1:length(use_UAV_index)
            if UE(u_).N_kind == UAV(use_UAV_index(d_)).N_kind
                d_2_UAV = sqrt((UE(u_).pos(1)-UAV(use_UAV_index(d_)).pos(1))^2+(UE(u_).pos(2)-UAV(use_UAV_index(d_)).pos(2))^2);
                PL = get_UAV_PL( config,d_2_UAV,UAV(use_UAV_index(d_)).h );
                PL_linear = 10^(0.1*PL);
                Tx_UAV = config.Tx_UAV;
                Pr_vector(d_) = Tx_UAV/PL_linear;
            else
                Pr_vector(d_) = 0;
            end
        end
        UE(u_).UAV_Pr = Pr_vector;
        UE(u_).get_MBS_SINR_random_after(config,UAV(use_UAV_index));% 宏小区的UE更新SINR
    else
        UE(u_).MBS_SINR_after = -inf;%UAV的UE的MBS SINR
    end
end

UE_MBS_SINR_after = [UE.MBS_SINR_after];

end