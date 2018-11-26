clc;
clear;
marker_color = {'r','g',[0.1 0.6 0.9],'c','b',[0.2 0.9 0.5],[0.5 0.2 0.9],[0.9 0.5 0.2],[0.6 0.1 0.3],[0.3 0.6 0.3],[0.7 0.3 0.2],[0.5 0.9 0.1],'m',[0.6 0.8 0.2],[0.2 0.9 0.5]};
linewidth=2.5;
current_marker_size=20;

figure;
ax=axes;
xlabel(ax,'ÁÚÆµ¸ÉÈÅ¹¦ÂÊ [dBm]');
ylabel(ax,'CDF');
ylim(ax,[0,1]);

hold all;
grid on;

% output=load('3/wco/Blocking_output_0.mat');
% range=load('3/wco/Blocking_range_0.mat');
% output=output.output;
% range=range.range;
% output(output>1)=1;
% displayname='without BF,¹²Ö·';
% plot(ax,range,output,'DisplayName',displayname,'LineWidth',linewidth,'Color',marker_color{1});

% output=load('3/wunco/Blocking_output_0.mat');
% range=load('3/wunco/Blocking_range_0.mat');
% output=output.output;
% range=range.range;
% output(output>1)=1;
% displayname='without BF,Æ«ÒÆ100%';
% plot(ax,range,output,'DisplayName',displayname,'LineWidth',linewidth,'Color',marker_color{2});
% 
% output=load('3/co/Blocking_output_0.mat');
% range=load('3/co/Blocking_range_0.mat');
% output=output.output;
% range=range.range;
% output(output>1)=1;
% displayname='with BF,¹²Ö·';
% plot(ax,range,output,'DisplayName',displayname,'LineWidth',linewidth,'Color',marker_color{3});
% 
output=load('3/unco/Blocking_output_0.mat');
range=load('3/unco/Blocking_range_0.mat');
output=output.output;
range=range.range;
output(output>1)=1;
displayname='with BF,Æ«ÒÆ100%';
plot(ax,range,output,'DisplayName',displayname,'LineWidth',linewidth,'Color',marker_color{4});

legend(ax,'show','Location','Best');