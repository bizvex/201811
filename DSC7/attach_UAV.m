function attach_UAV( config,UAV,UE,UAVcandidateUE,UE2UAVcandidate )
fprintf('UE attach UAV...\n');

for u_=1:length(UE)
    m_UAVpower=zeros(1,length(UAV));
    for d_=1:length(UAV)
        d_2_UAV = sqrt((UE(u_).pos(1)-UAV(d_).pos(1))^2+(UE(u_).pos(2)-UAV(d_).pos(2))^2);
        PL = get_UAV_PL( config,d_2_UAV,UAV(d_).h );
        PL_linear = 10^(0.1*PL);
        Tx_UAV = config.Tx_UAV;
        m_UAVpower(d_) = Tx_UAV/PL_linear;
    end
    UE(u_).m_UAVpower=m_UAVpower;
end

for d_ = 1:length(UAV)
    UE_in_UAV = UAVcandidateUE{d_};
    for u_ = UE_in_UAV'% 一定要是行向量才能这样写
        UE(u_).this2UAV = UE2UAVcandidate(u_);
        UE(u_).get_UAV_SINR_FFRA(config,d_);
    end
    
    m_UAV_SINR = [UE(UE_in_UAV).UAV_SINR];
    [~,index] = sort(m_UAV_SINR);
    
    u_ = 0;
    UAV_resource = 0;
    % 两类UE，一类是MBS服务，一类是UAV服务，所有UE都记得原来接入哪个MBS
    while true
        this_UE = UE(UE_in_UAV(index(end-u_)));
        if u_+1<length(index)
            u_ = u_ + 1;
            UAV_resource = UAV_resource + this_UE.D/log2(1+10^(0.1*this_UE.UAV_SINR));
            if UAV_resource <= UAV(d_).resource
                % 接入UAV
                this_UE.attach_UAV = UAV(d_);
                this_UE.attach_UAV.attachUE(this_UE);
                this_UE.belong2UAV=true;
                % 从MBS卸下
                this_UE.attach_MBS.deattachUE(this_UE);
                continue;
            else
                UAV_resource = UAV_resource - this_UE.D/(config.bandwidth*log2(1+10^(0.1*this_UE.UAV_SINR)));
                continue;
            end
        else
            break;
        end
    end
    
end

end








