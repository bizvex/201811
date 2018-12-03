clc;
clear;
markers  = {'.' 'd' 's' 'o','+','^','p','*','p','h'};
marker_color = {'r','g',[0.1 0.6 0.9],'c','b',[0.2 0.9 0.5],[0.5 0.2 0.9],[0.9 0.5 0.2],[0.6 0.1 0.3],[0.3 0.6 0.3],[0.7 0.3 0.2],[0.5 0.9 0.1],'m',[0.6 0.8 0.2],[0.2 0.9 0.5]};
linewidth=2.5;
current_marker_size=20;

UE=30:10:100;

figure;
ax=axes;
xlabel(ax,'ÿ��С���û���Ŀ');

% outage
ylabel(ax,'outage [%]');
y=[
    0.0185    0.0539    0.0930    0.1259    0.1799    0.2255    0.2518    0.2920;
    0.0786    0.1567    0.2455    0.3121    0.3760    0.4240    0.4652    0.4951;
    0.2080    0.3614    0.4851    0.5611    0.6320    0.6774    0.7098    0.7408;
    ].*100;

% % ƽ��SE
% ylabel(ax,'Ƶ��Ч�� [bps/Hz]');
% y=[
%     2.9341    2.9621    2.9625    3.0110    3.0287    2.9030    2.9733    2.9053;
%     2.1984    2.2146    2.1824    2.2031    2.1940    2.1684    2.1556    2.1703;
%     1.6359    1.6750    1.6547    1.6739    1.6345    1.6311    1.6352    1.6404;
%     ];

% % ƽ��MBS SE
% ylabel(ax,'Ƶ��Ч�� [bps/Hz]');
% y=[
%     2.0220    2.0668    2.0522    2.0947    2.0078    1.9851    1.9895    1.9815;
%     1.8002    1.8544    1.8259    1.8459    1.7944    1.7851    1.7772    1.7848;
%     1.6359    1.6750    1.6547    1.6739    1.6345    1.6311    1.6352    1.6404;
%     ];

% % ��ԵSE
% ylabel(ax,'Ƶ��Ч�� [bps/Hz]');
% y=[
%     0.7821    0.7595    0.7762    0.7816    0.7562    0.7460    0.7345    0.7195;
%     0.6688    0.6771    0.6766    0.6699    0.6679    0.6593    0.6485    0.6478;
%     0.6043    0.6019    0.6039    0.6041    0.6023    0.5989    0.5997    0.5978;
%     ];

% % ��ԵMBS SE
% ylabel(ax,'Ƶ��Ч�� [bps/Hz]');
% y=[
%     0.6829    0.6727    0.6729    0.6781    0.6609    0.6587    0.6500    0.6472;
%     0.6374    0.6476    0.6452    0.6425    0.6389    0.6354    0.6233    0.6246;
%     0.6043    0.6019    0.6039    0.6041    0.6023    0.5989    0.5997    0.5978;
%     ];


hold all;
grid on;
displayname={'K-means','random','without UAV'};
for i=1:size(y,1)
    current_marker=markers{i};
    current_marker_color=marker_color{i};
    if i==1
        current_marker_size=20;
    else
        current_marker_size=8;
    end
    plot(ax,UE,y(i,:),'DisplayName',displayname{i},'Marker',current_marker,'MarkerSize',current_marker_size,'LineWidth',linewidth,'Color',current_marker_color);
end
legend(ax,'show','Location','Best');