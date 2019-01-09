clear;
clc;
markers  = {'.' 'd' 's' 'o','+','^','p','*','p','h'};
marker_color = {'r','g',[0.1 0.6 0.9],'c','m',[0.2 0.9 0.5],[0.5 0.2 0.9],[0.9 0.5 0.2],[0.6 0.1 0.3],[0.3 0.6 0.3],[0.7 0.3 0.2],[0.5 0.9 0.1],'b',[0.6 0.8 0.2],[0.2 0.9 0.5]};
linewidth=2.5;
current_marker_size=20;
%% NR对LTE
% figure;
% ax=axes;
% xlabel(ax,'下行SINR [dB]');
% ylabel(ax,'CDF');
% hold all;
% grid on;
% for i=0:12
%     SINR_cdf=load(['0/NR2LTE1/SINR_cdf',num2str(i)]);
%     if(i~=12)
%         displayname=['ACIR=',num2str(5+i*5),'dB'];
%     else
%         displayname='ACIR=inf';
%     end
%     current_marker_color=marker_color{i+1};
%     [ range,output ] = getCDF( SINR_cdf );
%     plotcdfsmooth(ax,range,output,displayname,linewidth,current_marker_color);
% end
% legend(ax,'show','Location','Best');
% 
% figure;
% ax=axes;
% xlabel(ax,'上行SINR [dB]');
% ylabel(ax,'CDF');
% hold all;
% grid on;
% for i=0:12
%     SINR_cdf=load(['0/NR2LTE1/SINRUL_cdf',num2str(i)]);
%     if(i~=12)
%         displayname=['ACIR=',num2str(5+i*5),'dB'];
%     else
%         displayname='ACIR=inf';
%     end
%     current_marker_color=marker_color{i+1};
%     [ range,output ] = getCDF( SINR_cdf );
%     plotcdfsmooth(ax,range,output,displayname,linewidth,current_marker_color);
% end
% legend(ax,'show','Location','Best');
% 
% figure;
% ax=axes;
% xlabel(ax,'ACIR [dB]');
% ylabel(ax,'下行平均吞吐量损失 [%]');
% hold all;
% grid on;
% loss=load('0/NR2LTE1/tploss');
% loss=loss(1:end-1);
% plot(ax,[5:5:60],loss,'DisplayName','下行单用户','Marker','.','MarkerSize',current_marker_size,'LineWidth',linewidth,'Color','b');
% plot(ax,[5:5:60],5*ones(size(5:5:60)),'--m','DisplayName','基准','MarkerSize',current_marker_size,'LineWidth',linewidth);
% xlim(ax,[5,60]);
% legend(ax,'show','Location','Best');
% 
% figure;
% ax=axes;
% xlabel(ax,'ACIR [dB]');
% ylabel(ax,'下行边缘用户吞吐量损失 [%]');
% hold all;
% grid on;
% loss=load('0/NR2LTE1/tp5loss');
% loss=loss(1:end-1);
% plot(ax,[5:5:60],loss,'DisplayName','下行单用户','Marker','.','MarkerSize',current_marker_size,'LineWidth',linewidth,'Color','b');
% plot(ax,[5:5:60],5*ones(size(5:5:60)),'--m','DisplayName','基准','MarkerSize',current_marker_size,'LineWidth',linewidth);
% xlim(ax,[5,60]);
% legend(ax,'show','Location','Best');
% 
% 
% figure;
% ax=axes;
% xlabel(ax,'ACIR [dB]');
% ylabel(ax,'上行平均吞吐量损失 [%]');
% hold all;
% grid on;
% loss=load('0/NR2LTE1/tpulloss');
% loss=loss(1:end-1);
% plot(ax,[5:5:60],loss,'DisplayName','上行单用户','Marker','.','MarkerSize',current_marker_size,'LineWidth',linewidth,'Color','b');
% plot(ax,[5:5:60],5*ones(size(5:5:60)),'--m','DisplayName','基准','MarkerSize',current_marker_size,'LineWidth',linewidth);
% xlim(ax,[5,60]);
% legend(ax,'show','Location','Best');
% 
% figure;
% ax=axes;
% xlabel(ax,'ACIR [dB]');
% ylabel(ax,'上行边缘用户吞吐量损失 [%]');
% hold all;
% grid on;
% loss=load('0/NR2LTE1/tpul5loss');
% loss=loss(1:end-1);
% plot(ax,[5:5:60],loss,'DisplayName','上行单用户','Marker','.','MarkerSize',current_marker_size,'LineWidth',linewidth,'Color','b');
% plot(ax,[5:5:60],5*ones(size(5:5:60)),'--m','DisplayName','基准','MarkerSize',current_marker_size,'LineWidth',linewidth);
% xlim(ax,[5,60]);
% legend(ax,'show','Location','Best');
% 
% % 上行不同用户数平均吞吐量损失
% figure;
% ax=axes;
% xlabel(ax,'ACIR [dB]');
% ylabel(ax,'上行平均吞吐量损失 [%]');
% hold all;
% grid on;
% for i=0:3
%     if i~=0
%         loss=load(['0/NR2LTE',num2str(i*3),'/tpulloss']);
%         displayname=['上行',num2str(i*3),'用户'];
%     else
%         loss=load('0/NR2LTE1/tpulloss');
%         displayname='上行单用户';
%     end
%     if i==0
%         current_marker_size=20;
%     else
%         current_marker_size=8;
%     end
%     current_marker=markers{i+1};
%     current_marker_color=marker_color{i+1};
%     loss=loss(1:end-1);
%     plot(ax,[5:5:60],loss,'DisplayName',displayname,'Marker',current_marker,'MarkerSize',current_marker_size,'LineWidth',linewidth,'Color',current_marker_color);
% end
% plot(ax,[5:5:60],5*ones(size(5:5:60)),'--m','DisplayName','基准','MarkerSize',current_marker_size,'LineWidth',linewidth);
% xlim(ax,[5,60]);
% legend(ax,'show','Location','Best');

%% LTE对NR
figure;
ax=axes;
xlabel(ax,'下行SINR [dB]');
ylabel(ax,'CDF');
hold all;
grid on;
for i=0:12
    SINR_cdf=load(['0/LTE2NR1/SINR_cdf',num2str(i)]);
    if(i~=12)
        displayname=['ACIR=',num2str(5+i*5),'dB'];
    else
        displayname='ACIR=inf';
    end
    current_marker_color=marker_color{i+1};
    [ range,output ] = getCDF( SINR_cdf );
    plotcdfsmooth(ax,range,output,displayname,linewidth,current_marker_color);
end
legend(ax,'show','Location','Best');

figure;
ax=axes;
xlabel(ax,'上行SINR [dB]');
ylabel(ax,'CDF');
hold all;
grid on;
for i=0:12
    SINR_cdf=load(['0/LTE2NR1/SINRUL_cdf',num2str(i)]);
    if(i~=12)
        displayname=['ACIR=',num2str(5+i*5),'dB'];
    else
        displayname='ACIR=inf';
    end
    current_marker_color=marker_color{i+1};
    [ range,output ] = getCDF( SINR_cdf );
    plotcdfsmooth(ax,range,output,displayname,linewidth,current_marker_color);
end
legend(ax,'show','Location','Best');

figure;
ax=axes;
xlabel(ax,'ACIR [dB]');
ylabel(ax,'下行平均吞吐量损失 [%]');
hold all;
grid on;
loss=load('0/LTE2NR1/tploss');
loss=loss(1:end-1);
plot(ax,[5:5:60],loss,'DisplayName','下行单用户','Marker','.','MarkerSize',current_marker_size,'LineWidth',linewidth,'Color','b');
plot(ax,[5:5:60],5*ones(size(5:5:60)),'--m','DisplayName','基准','MarkerSize',current_marker_size,'LineWidth',linewidth);
xlim(ax,[5,60]);
legend(ax,'show','Location','Best');

figure;
ax=axes;
xlabel(ax,'ACIR [dB]');
ylabel(ax,'下行边缘用户吞吐量损失 [%]');
hold all;
grid on;
loss=load('0/LTE2NR1/tp5loss');
loss=loss(1:end-1);
plot(ax,[5:5:60],loss,'DisplayName','下行单用户','Marker','.','MarkerSize',current_marker_size,'LineWidth',linewidth,'Color','b');
plot(ax,[5:5:60],5*ones(size(5:5:60)),'--m','DisplayName','基准','MarkerSize',current_marker_size,'LineWidth',linewidth);
xlim(ax,[5,60]);
legend(ax,'show','Location','Best');

figure;
ax=axes;
xlabel(ax,'ACIR [dB]');
ylabel(ax,'上行平均吞吐量损失 [%]');
hold all;
grid on;
loss=load('0/LTE2NR1/tpulloss');
loss=loss(1:end-1);
plot(ax,[5:5:60],loss,'DisplayName','上行单用户','Marker','.','MarkerSize',current_marker_size,'LineWidth',linewidth,'Color','b');
plot(ax,[5:5:60],5*ones(size(5:5:60)),'--m','DisplayName','基准','MarkerSize',current_marker_size,'LineWidth',linewidth);
xlim(ax,[5,60]);
legend(ax,'show','Location','Best');

figure;
ax=axes;
xlabel(ax,'ACIR [dB]');
ylabel(ax,'上行边缘用户吞吐量损失 [%]');
hold all;
grid on;
loss=load('0/LTE2NR1/tpul5loss');
loss=loss(1:end-1);
plot(ax,[5:5:60],loss,'DisplayName','上行单用户','Marker','.','MarkerSize',current_marker_size,'LineWidth',linewidth,'Color','b');
plot(ax,[5:5:60],5*ones(size(5:5:60)),'--m','DisplayName','基准','MarkerSize',current_marker_size,'LineWidth',linewidth);
xlim(ax,[5,60]);
legend(ax,'show','Location','Best');

% 上行不同用户数平均吞吐量损失
figure;
ax=axes;
xlabel(ax,'ACIR [dB]');
ylabel(ax,'上行平均吞吐量损失 [%]');
hold all;
grid on;
for i=0:3
    if i~=0
        loss=load(['0/LTE2NR',num2str(i*3),'/tpulloss']);
        displayname=['上行',num2str(i*3),'用户'];
    else
        loss=load('0/LTE2NR1/tpulloss');
        displayname='上行单用户';
    end
    if i==0
        current_marker_size=20;
    else
        current_marker_size=8;
    end
    current_marker=markers{i+1};
    current_marker_color=marker_color{i+1};
    loss=loss(1:end-1);
    plot(ax,[5:5:60],loss,'DisplayName',displayname,'Marker',current_marker,'MarkerSize',current_marker_size,'LineWidth',linewidth,'Color',current_marker_color);
end
plot(ax,[5:5:60],5*ones(size(5:5:60)),'--m','DisplayName','基准','MarkerSize',current_marker_size,'LineWidth',linewidth);
xlim(ax,[5,60]);
legend(ax,'show','Location','Best');






