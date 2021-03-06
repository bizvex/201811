clc;
clear;
markers  = {'.' 'd' 's' 'o','+','^','p','*','p','h'};
marker_color = {'r','g',[0.1 0.6 0.9],'c','b',[0.2 0.9 0.8],[0.5 0.2 0.9],[0.9 0.5 0.2],[0.6 0.1 0.3],[0.3 0.6 0.3],[0.7 0.3 0.2],[0.5 0.9 0.1],'m',[0.6 0.8 0.2],[0.2 0.9 0.5]};
linewidth=2.5;
current_marker_size=20;

ACIR=0:5:40;

figure;
ax=axes;
xlabel(ax,'ACIR [dB]');

% ylabel(ax,'系统平均吞吐量损失 [%]');
% before=[1.6739    1.6739    1.6739    1.6739    1.6739    1.6739    1.6739    1.6739    1.6739];
% after=[ 1.2885    1.8124    2.3115    2.7271    3.0110    3.1703    3.2431    3.2709    3.2804];
% MBSafter=[ 1.3251    1.7870    2.0074    2.0758    2.0947    2.1002    2.1019    2.1025    2.1027];
% after2=[ 1.3065    1.5963    1.8571    2.0632    2.2031    2.2838    2.3223    2.3376    2.3430];
% MBSafter2=[ 1.3171    1.6277    1.7850    1.8323    1.8459    1.8500    1.8511    1.8517    1.8518];
% after3=[ 0.9070    1.5737    2.3116    2.9114    3.3485    3.6017    3.7183    3.7629    3.7781];
% MBSafter3=[ 0.9193    1.5815    2.0591    2.1883    2.2083    2.2084    2.2072    2.2067    2.2062];
% % after3=[ 1.1070    1.6737    2.3116    2.9114    3.3485    3.6017    3.7183    3.7629    3.7781];
% % MBSafter3=[1.1193    1.6815    2.0591    2.1883    2.2083    2.2084    2.2072    2.2067    2.2062];

ylabel(ax,'边缘用户吞吐量损失 [%]');
before=[0.6041    0.6041    0.6041    0.6041    0.6041    0.6041    0.6041    0.6041    0.6041];
after=[0.3508    0.6076    0.7216    0.7690    0.7816    0.7868    0.7885    0.7889    0.7890];
MBSafter=[0.3434    0.5634    0.6388    0.6694    0.6781    0.6818    0.6826    0.6827    0.6828];
after2=[0.3895    0.5875    0.6469    0.6644    0.6699    0.6715    0.6719    0.6723    0.6723];
MBSafter2=[0.3889    0.5769    0.6251    0.6386    0.6425    0.6441    0.6443    0.6446    0.6446];
after3=[ 0.1837    0.4989    0.7480    0.8531    0.8887    0.8945    0.8977    0.8985    0.8986];
MBSafter3=[ 0.1810    0.4621    0.6437    0.6923    0.7041    0.7071    0.7084    0.7085    0.7086];
% after3=[ 0.3837    0.5989    0.7480    0.8531    0.8887    0.8945    0.8977    0.8985    0.8986];
% MBSafter3=[ 0.3810    0.5621    0.6437    0.6923    0.7041    0.7071    0.7084    0.7085    0.7086];

displayname={'K-means,整体系统','K-means,宏蜂窝系统','random,整体系统','random,宏蜂窝系统','normal K-means,整体系统','normal K-means,宏蜂窝系统'};

hold all;
grid on;
plot(ACIR,(before-after)./before*100,'DisplayName',displayname{1},'Marker',markers{1},'MarkerSize',20,'LineWidth',linewidth,'Color',marker_color{1});
plot(ACIR,(before-MBSafter)./before*100,'DisplayName',displayname{2},'Marker',markers{2},'MarkerSize',8,'LineWidth',linewidth,'Color',marker_color{2});
plot(ACIR,(before-after2)./before*100,'DisplayName',displayname{3},'Marker',markers{3},'MarkerSize',8,'LineWidth',linewidth,'Color',marker_color{3});
plot(ACIR,(before-MBSafter2)./before*100,'DisplayName',displayname{4},'Marker',markers{4},'MarkerSize',8,'LineWidth',linewidth,'Color',marker_color{4});
plot(ACIR,(before-after3)./before*100,'DisplayName',displayname{5},'Marker',markers{5},'MarkerSize',8,'LineWidth',linewidth,'Color',marker_color{5});
plot(ACIR,(before-MBSafter3)./before*100,'DisplayName',displayname{6},'Marker',markers{6},'MarkerSize',8,'LineWidth',linewidth,'Color',marker_color{6});

plot(ax,ACIR,5*ones(size(ACIR)),'--m','DisplayName','基准','MarkerSize',current_marker_size,'LineWidth',linewidth);
xlim(ax,[0,40]);
legend(ax,'show','Location','Best');