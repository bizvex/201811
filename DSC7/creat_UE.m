function [ UE ] = creat_UE( config )

fprintf('UE...\n');
config.n_UE = config.n_UE_per_MBS*config.n_MBS;
for u_ = 1:config.n_UE
    UE(u_) =  network_elements.UE;
    UE(u_).id = u_;
    R = [0.1 0.5 1 1.5 2]*1e6;% Mbps
    index = randperm(length(R),1);
    UE(u_).D = R(index);
    UE(u_).belong2UAV = false;
end

end
