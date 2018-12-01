function [ UE_pos ] = creat_UEpos( config,MBS,UE )

fprintf('UE pos...\n');
ISD = config.ISD;
MBS_r = ISD/2/sqrt(3)*2;
map_r = MBS_r+ISD;
hotspot_r = 40;

n_UE_lpn = floor(config.P_hotspot*config.n_UE_per_MBS/config.n_hotspot_per_MBS);
UE_pos = zeros(length(UE),2);
u_ = 1;
for b_ = 1:length(MBS)
    hotspot_pos = spatial_in_circle(MBS_r,config.n_hotspot_per_MBS,MBS(b_).pos);
    for h_ = 1:config.n_hotspot_per_MBS
        UE_pos(u_:u_+n_UE_lpn-1,:) = spatial_in_circle(hotspot_r,n_UE_lpn,hotspot_pos(h_,:));
        u_ = u_+n_UE_lpn;
    end
    remaining = config.n_UE_per_MBS-n_UE_lpn*config.n_hotspot_per_MBS;
    UE_pos(u_:u_+remaining-1,:) = spatial_in_circle(MBS_r,remaining,MBS(b_).pos);
    u_ = u_+remaining;
end

for u_ = 1:length(UE)
    UE(u_).pos = UE_pos(u_,:);
end

end

