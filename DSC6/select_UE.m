function select_UE( config,UAV,UE,extra,UAVcandidateUE,UE2UAVcandidate )
fprintf('UE attach UAV...\n');

for d_ = 1:length(UAV)
    UE_in_UAV_r = UAVcandidateUE{d_};
    for u_ = UE_in_UAV_r'% һ��Ҫ����������������д
        UE(u_).this2UAV = UE2UAVcandidate(u_);
        a = UE(u_).this2UAV/extra.map_r;
        % ֱ����best cqi
        F1 = -a;% aԽС��bԽ��cԽ��ԽӦ�ý���UAV
        % aԽС��-aԽ��UE��UAVԽ��
        UE(u_).F1 = F1;
        switch config.type
            case 'FFRA'
                UE(u_).get_UAV_SINR_FFRA(config,UE(u_).this2UAV,UAV(d_));
        end
    end
    
    F1_vector = [UE(UE_in_UAV_r).F1];
    [~,index] = sort(F1_vector);%F1 Խ����Ӧ�ý���
    
    u_ = 0;
    UAV_N = 0;
    % ����UE��һ����MBS����һ����UAV��������UE���ǵ�ԭ�������ĸ�MBS
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








