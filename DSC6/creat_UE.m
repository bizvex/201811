function [ UE ] = creat_UE( config )

fprintf('UE...\n');
for u_ = 1:config.n_UE
    UE(u_) =  network_elements.UE;
    UE(u_).id = u_;
    R = [0.1 0.5 1 1.5 2]*1e6;% Mbps
    index = randperm(length(R),1);
    UE(u_).D = R(index);
    UE(u_).F1 = -inf;
    UE(u_).request_UAV_handover = false;
    UE(u_).belong2UAV = false;
    
    UE(u_).MBS_ser_BF=15.5+3*rand(1,1); %10~21+15,均值15.5，方差3
    UE(u_).MBS_in_BF=-15+3*rand(1,1);
    UE(u_).UAV_ser_BF=9+2*rand(1,1); %6~12+10,均值9，方差2
    UE(u_).UAV_in_BF=-10+2*rand(1,1); 
end

end
