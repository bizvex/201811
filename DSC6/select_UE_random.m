function select_UE_random( config,UAV,UE,extra,UAVcandidateUE,UE2UAVcandidate )
fprintf('UE attach UAV...\n');

for d_ = 1:length(UAV)
    UE_in_UAV_r = UAVcandidateUE{d_};
    for u_ = UE_in_UAV_r'% 一定要是行向量才能这样写
        UE(u_).this2UAV = UE2UAVcandidate(u_);
        a = UE(u_).this2UAV/extra.map_r;
        b = UE(u_).this2MBS/extra.map_r;
        c = extra.UE_D(u_);
        F1 = -a;% 直接用best cqi
        UE(u_).F1 = F1;
        UE(u_).get_UAV_SINR_random(config,UE(u_).this2UAV,UAV(d_));
    end
    
    F1_vector = [UE(UE_in_UAV_r).F1];
    [~,index] = sort(F1_vector);
    
    u_ = 0;
    UAV_N = 0;
    % 两类UE，一类是MBS服务，一类是UAV服务，所有UE都记得原来接入哪个MBS
    while true
        this_UE = UE(UE_in_UAV_r(index(end-u_)));
        if u_+1<length(index)
            u_ = u_ + 1;
            UAV_N = UAV_N + this_UE.D/log2(1+10^(0.1*this_UE.UAV_SINR));
            if UAV_N <= UAV(d_).N_max
                this_UE.attach_UAV = UAV(d_);
                this_UE.attach_UAV.attachUE(this_UE);
                continue;
            else
                UAV_N = UAV_N - this_UE.D/(config.bandwidth*log2(1+10^(0.1*this_UE.UAV_SINR)));
                continue;
            end
        else
            break;
        end
    end
    
end

end








