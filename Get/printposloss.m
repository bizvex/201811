clc;
clear;
markers  = {'.' 'd' 's' 'o','+','^','p','*','p','h'};
marker_color = {'r','g',[0.1 0.6 0.9],'c','b',[0.2 0.9 0.5],[0.5 0.2 0.9],[0.9 0.5 0.2],[0.6 0.1 0.3],[0.3 0.6 0.3],[0.7 0.3 0.2],[0.5 0.9 0.1],'m',[0.6 0.8 0.2],[0.2 0.9 0.5]};
linewidth=2.5;
current_marker_size=20;

figure;
ax=axes;
xlabel(ax,'ACIR [dB]');

% ylabel(ax,'ϵͳƽ����������ʧ [%]');
% loss=[
%     11.148477 6.098784 3.193460 1.551531 0.663818 0.226946 0.074109 0.026373;
%     9.151168 5.498492 3.136111 1.735044 0.877764 0.373706 0.147710 0.057777;
%     8.736177 4.826935 2.509866 1.234097 0.572463 0.277056 0.135786 0.071010;
%     ];

% ylabel(ax,'��Ե�û���������ʧ [%]');
% loss=[
%     27.532056 9.077275 1.891008 0.685777 0.240148 0.090380 0.022332 0.007073;
%     38.090893 26.569152 17.126318 9.159646 4.720229 1.607157 0.558682 0.182993;
%     27.819643 14.700357 4.112916 2.053216 1.685232 0.057426 0.018229 0.005771;
%     ];

% ylabel(ax,'ϵͳƽ����������ʧ [%]');
% loss=[
%     46.388132 29.485541 16.137465 7.629327 3.154406 1.179540 0.412494 0.137458;
%     39.040666 25.379216 14.645560 7.402353 3.307311 1.343038 0.503748 0.175741;
%     40.546794 26.124312 14.698617 7.176915 3.044698 1.148099 0.394827 0.129004;
%     ];

ylabel(ax,'��Ե�û���������ʧ [%]');
loss=[
    100.000000 63.372102 2.460937 0.795326 0.253267 0.080268 0.025401 0.008034;
    100 100 100 100 100 100 100 100;
    100.000000 100.000000 100.000000 100.000000 33.151342 0.028952 0.009157 0.002896;
    ];

displayname={'��ַ','ƫ��141m','ƫ��100%'};

hold all;
grid on;
for i=1:size(loss,1)
    current_marker=markers{i};
    current_marker_color=marker_color{i};
    if i==1
        current_marker_size=20;
    else
        current_marker_size=8;
    end
    length(displayname)
    plot(ax,[5:5:40],loss(i,:),'DisplayName',displayname{i},'Marker',current_marker,'MarkerSize',current_marker_size,'LineWidth',linewidth,'Color',current_marker_color);
end
plot(ax,[5:5:40],5*ones(size(5:5:40)),'--m','DisplayName','��׼','MarkerSize',current_marker_size,'LineWidth',linewidth);
xlim(ax,[5,40]);
legend(ax,'show','Location','Best');