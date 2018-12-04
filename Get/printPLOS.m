clc;
clear;
marker_color = {'r','g',[0.1 0.6 0.9],'c','b',[0.2 0.9 0.5],[0.5 0.2 0.9],[0.9 0.5 0.2],[0.6 0.1 0.3],[0.3 0.6 0.3],[0.7 0.3 0.2],[0.5 0.9 0.1],'m',[0.6 0.8 0.2],[0.2 0.9 0.5]};
linewidth=2.5;
current_marker_size=20;

figure;
ax=axes;
xlabel(ax,'LOS¸ÅÂÊ');
ylabel(ax,'CDF');
ylim(ax,[0,1]);

hold all;
grid on;

for i=0:2
    filename=sprintf('7PLOS/%d.mat',i);
    tmp=load(filename);
    m_PLOS_set=tmp.m_PLOS_set;
    m_PLOS=[];
    for j=1:length(m_PLOS_set)
        m_PLOS=[m_PLOS,m_PLOS_set{j}];
    end
    
    min_ = floor(min(m_PLOS));
    max_ = ceil(max(m_PLOS));
    range = min_:0.001:max_;
    h = hist(m_PLOS,range);
    output = cumsum(h)/sum(h);

    if i==0
        displayname='50m';
    elseif i==1
        displayname='100m';
    else
        displayname='150m';
    end
    current_marker_color=marker_color{i+1};
    plot(ax,range,output,'DisplayName',displayname,'LineWidth',linewidth,'Color',current_marker_color);
end

legend(ax,'show','Location','Best');