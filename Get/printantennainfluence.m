clear;
clc;

markers  = {'.' '*' 's' 'o','+','^','p','d','p','h'};
marker_color = {'r','g',[0.1 0.6 0.9],'c','m',[0.2 0.9 0.5],[0.5 0.2 0.9],[0.9 0.5 0.2],[0.6 0.1 0.3],[0.3 0.6 0.3],[0.7 0.3 0.2],[0.5 0.9 0.1],'b',[0.6 0.8 0.2],[0.2 0.9 0.5]};
linewidth=2.5;
current_marker_size=20;

figure;
ax=axes;
xlabel(ax,'下行SINR [dB]');
ylabel(ax,'CDF');
hold all;
grid on;

SINR_cdf=load('1/0x0/R_sinr.txt');
displayname='without BF';
current_marker=markers{5};
current_marker_color=marker_color{5};
[ range,output ] = getCDF( SINR_cdf );
plotcdfsmooth(ax,range,output,displayname,linewidth,current_marker_color);

SINR_cdf=load('1/2x2/R_sinr.txt');
displayname='2x2';
current_marker=markers{1};
current_marker_color=marker_color{1};
[ range,output ] = getCDF( SINR_cdf );
plotcdfsmooth(ax,range,output,displayname,linewidth,current_marker_color);

SINR_cdf=load('1/4x4/R_sinr.txt');
displayname='4x4';
current_marker=markers{2};
current_marker_color=marker_color{2};
[ range,output ] = getCDF( SINR_cdf );
plotcdfsmooth(ax,range,output,displayname,linewidth,current_marker_color);

SINR_cdf=load('1/8x8/R_sinr.txt');
displayname='8x8';
current_marker=markers{3};
current_marker_color=marker_color{3};
[ range,output ] = getCDF( SINR_cdf );
plotcdfsmooth(ax,range,output,displayname,linewidth,current_marker_color);

SINR_cdf=load('1/16x8/R_sinr.txt');
displayname='16x8';
current_marker=markers{4};
current_marker_color=marker_color{4};
[ range,output ] = getCDF( SINR_cdf );
plotcdfsmooth(ax,range,output,displayname,linewidth,current_marker_color);

legend(ax,'show','Location','Best');

figure;
tp=[298.5503,549.8225,735.2509,940.4163,1028.4793];
tp5=[6.3181,74.5142,152.3443,275.1282,402.8539];
tpall=zeros(4,2);
for i=1:5
    tpall(i,1)=tp(i);
    tpall(i,2)=tp5(i);
end
bar(tpall,'hist');
xlabel('天线配置')
ylabel('吞吐量 [Mbps]')
legend('系统平均吞吐量','边缘用户吞吐量');
grid on;
set(gca,'xticklabel',{'without BF','2x2','4x4','8x8','16x8'});
