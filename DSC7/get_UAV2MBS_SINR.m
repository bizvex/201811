function [DL2ULSINR,DL2ULSINRnoUAV]=get_UAV2MBS_SINR(config,MBS,UAV)
% UAV下行干扰MBS上行
DL2ULSINR=[];
DL2ULSINRnoUAV=[];
for b_=1:length(MBS)
    attach_UE_vector=MBS(b_).attach_UE_vector;
    if isempty(attach_UE_vector)
        continue;
    end
    
    noise_power = config.noise_power;
    
    MBS_interference_power=0;
    for i=[1:b_-1,b_+1:length(MBS)]
        d_2d=sqrt((MBS(b_).pos(1)-MBS(i).pos(1))^2+(MBS(b_).pos(2)-MBS(i).pos(2))^2);
        PL=get_MBS_PL( config,d_2d,15 );
        PL_linear=invdB(PL);
        MBS_interference_power=MBS_interference_power+config.Tx_MBS/PL_linear;
    end
    
    UAV_interference_power=0;
    for i=1:length(UAV)
        d_2d=sqrt((MBS(b_).pos(1)-UAV(i).pos(1))^2+(MBS(b_).pos(2)-UAV(i).pos(2))^2);
        PL = get_UAV_PL( config,d_2d,UAV(i).h,15 );
        PL_linear=invdB(PL);
        UAV_interference_power=UAV_interference_power+config.Tx_UAV/PL_linear/invdB(config.ACIR);
    end
    
    for u=attach_UE_vector
        PL=get_MBS_PL( config,u.this2MBS,1.5 );
        PL_linear=invdB(PL);
        signal_power=10^2.3/1000/PL_linear;
        SINR=dB(signal_power/(MBS_interference_power+UAV_interference_power+noise_power));
        DL2ULSINR=[DL2ULSINR,SINR];
        SINR=dB(signal_power/(MBS_interference_power+noise_power));
        DL2ULSINRnoUAV=[DL2ULSINRnoUAV,SINR];
    end
end



end