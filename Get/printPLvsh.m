clc;
clear;
marker_color = {'r','g',[0.1 0.6 0.9],'c','b',[0.2 0.9 0.5],[0.5 0.2 0.9],[0.9 0.5 0.2],[0.6 0.1 0.3],[0.3 0.6 0.3],[0.7 0.3 0.2],[0.5 0.9 0.1],'m',[0.6 0.8 0.2],[0.2 0.9 0.5]};
linewidth=2.5;
current_marker_size=20;

frequency = 4e9;
alpha = 9.6;
beta = 0.28;
extra_LOS = 1;
extra_NLOS = 20;

h = 0:1000;
Rset = 100:100:400;

figure;
ax=axes;
xlabel(ax,'无人机高度 [m]');
ylabel(ax,'路径损耗 [dB]')
hold all;
grid on;
for r=Rset

theta = atan(h./r);
d_3d = sqrt(r.^2+h.^2);
P_LOS = 1./(1+alpha.*exp(-beta.*(180.*theta./pi-alpha)));
PL_LOS = 20.*log10(4.*pi.*frequency.*d_3d./3e8)+extra_LOS;
PL_NLOS = 20.*log10(4.*pi.*frequency.*d_3d./3e8)+extra_NLOS;
PL = P_LOS.*PL_LOS + (1-P_LOS).*PL_NLOS;

displayname=sprintf('%dm',r);
current_marker_color=marker_color{r/100};
plot(ax,h,PL,'DisplayName',displayname,'LineWidth',linewidth,'Color',current_marker_color);

end

legend(ax,'show','Location','Best');