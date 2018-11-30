function  update_N_kind( config,MBS,UAV,UE,use_UAV_index )
% 更新资源分配状况
for d_ = 1:length(use_UAV_index)
    switch config.type
        case 'FFRE'
            UAV(use_UAV_index(d_)).N_kind = 0;
        otherwise
            UAV(use_UAV_index(d_)).N_kind = d_;
    end
end
for b_ = 1:length(MBS)
    switch config.type
        case 'FFRA'
            MBS(b_).N_kind = 0;% FFRA
            MBS(b_).N_max = (1-config.a)*config.bandwidth;
    end
end
for u_ = 1:length(UE)
    if UE(u_).belong2UAV
        UE(u_).N_kind = UE(u_).attach_UAV.N_kind;
    else
        UE(u_).N_kind = 0;
    end
end

end

