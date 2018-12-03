function [ PL ] = get_MBS_PL( config,d_2d,UE_h )
frequency = config.frequency;
h_BS = 15;
h_UE = UE_h;
d_3d = sqrt(d_2d^2 + (h_BS - h_UE)^2);

extra_LOS = 1;
extra_NLOS = 20;

PL_LOS = 20*log10(4*pi*frequency*d_3d/3e8)+extra_LOS;
PL_NLOS = 20*log10(4*pi*frequency*d_3d/3e8)+extra_NLOS;

P_LOS = 0.5;

PL = P_LOS*PL_LOS + (1-P_LOS)*PL_NLOS;

end

