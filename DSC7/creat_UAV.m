function UAV = creat_UAV( config,UAVcandidate_pos )

fprintf('UAV...\n');

for d_ = 1:size(UAVcandidate_pos,1)
    UAV(d_) = network_elements.UAV;
    UAV(d_).id = d_;
    UAV(d_).pos = UAVcandidate_pos(d_,:);
    UAV(d_).h = 150;
    UAV(d_).attach_UE_vector = [];
    UAV(d_).resource = config.bandwidth;
end


end

