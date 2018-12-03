function [ UE ] = creat_UE( config )

fprintf('UE...\n');
config.n_UE = config.n_UE_per_MBS*config.n_MBS;
for u_ = 1:config.n_UE
    UE(u_) =  network_elements.UE;
    UE(u_).id = u_;
    UE(u_).D = 1e6;% bps
    UE(u_).belong2UAV = false;
end

end
