function [ PL ] = get_MBS_PL( config,d_2d )

h_BS = 15;
h_UE = 1.5;
d_3d = sqrt(d_2d^2 + (h_BS - h_UE)^2);

PL_LOS = 30.8+24.2*log10(d_3d);
PL_NLOS = 2.7+42.8*log10(d_3d);

P_LOS = min(18/d_3d,1)*(1-exp(-d_3d/63))+exp(-d_3d/63);

PL = P_LOS*PL_LOS + (1-P_LOS)*PL_NLOS;

end

