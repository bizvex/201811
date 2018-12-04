function [ PL,P_LOS ] = get_UAV_PL( config,d_2d,h,UE_h )

h_UAV = h;
h_UE = UE_h;
alpha = 9.6;
beta = 0.28;
extra_LOS = 1;
extra_NLOS = 20;
frequency = config.frequency;

d_3d = sqrt(d_2d^2 + (h_UAV - h_UE)^2);
theta = atan((h_UAV - h_UE)/d_2d);
P_LOS = 1/(1+alpha*exp(-beta*(180*theta/pi-alpha)));

PL_LOS = 20*log10(4*pi*frequency*d_3d/3e8)+extra_LOS;
PL_NLOS = 20*log10(4*pi*frequency*d_3d/3e8)+extra_NLOS;

PL = P_LOS*PL_LOS + (1-P_LOS)*PL_NLOS;



end

