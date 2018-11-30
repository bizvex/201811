function  update_N_kind_random( config,MBS,UAV,UE,use_UAV_index )
% 更新资源分配状况
for d_ = 1:length(use_UAV_index)
    UAV(use_UAV_index(d_)).N_kind = d_;
end
for b_ = 1:length(MBS)
    cell_N_kind = 1:config.n_UAV;
    MBS(b_).N_kind = cell_N_kind;
    MBS(b_).N_max = config.bandwidth;
end
for u_ = 1:length(UE)
    if UE(u_).belong2UAV
        UE(u_).N_kind = UE(u_).attach_UAV.N_kind;
    else
        cell_N_kind = MBS(UE(u_).attach_MBS.id).N_kind;
        UE(u_).N_kind = cell_N_kind(randperm(length(cell_N_kind),1));
    end
end

end

