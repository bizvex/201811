function UAV = creat_UAV( config,UAVcandidate_pos,MBS )

fprintf('UAV...\n');

for d_ = 1:size(UAVcandidate_pos,1)
    UAV(d_) = network_elements.UAV;
    UAV(d_).id = d_;
    UAV(d_).pos = UAVcandidate_pos(d_,:);
    UAV(d_).h = 150;
    UAV(d_).isUse = false;
    UAV(d_).attach_UE_vector = [];
    
    switch config.type
        case 'FFRA'
            UAV(d_).N_max = config.bandwidth*config.a;
        case 'FFRB'
            UAV(d_).N_max = config.bandwidth/config.n_UAV;
        case 'FFRC'
            UAV(d_).N_max = config.bandwidth*(1-config.c)/config.n_UAV;
        case 'FFRD'
            UAV(d_).N_max = config.bandwidth/config.n_UAV;
        case 'FFRE'
            UAV(d_).N_max = config.bandwidth;
    end
    
    d_vector = zeros(1,length(MBS));
    for b_ = 1:length(MBS)
        d_vector(b_) = sqrt((MBS(b_).pos(1)-UAV(d_).pos(1))^2+(MBS(b_).pos(2)-UAV(d_).pos(2))^2);
    end
    [d_sort,index] = sort(d_vector);
    UAV(d_).attach_MBS = MBS(index(1));
    UAV(d_).attach_MBS.attachUAV(UAV(d_));
    UAV(d_).this2MBS = d_sort(1);
end


end

