function [ results_filename ] = gen_file_name( config,num )

the_date = clock;
date_time_string = sprintf('%04d%02d%02d_%02d%02d%02d',...
    the_date(1),...                     % Date: year
    the_date(2),...                     % Date: month
    the_date(3),...                     % Date: day
    the_date(4),...                     % Date: hour
    the_date(5),...                     % Date: minutes
    floor(the_date(6)));                % Date: seconds

if config.frequency/1e9 >= 1
    this_freq = sprintf('%dGHz',config.frequency/1e9);
else
    this_freq = sprintf('%dMHz',config.frequency/1e6);
end

this_bw = sprintf('%gfMHz',config.bandwidth/1e6);

if strcmp(config.type,'FFRA')
    type = [config.type num2str(config.a)];
else
    type = config.type;
end

results_filename = sprintf('%s_%s_%dsnap_%dUE_%dUAV_%s_%d_%s.mat',...
    this_freq,...                             % 频率
    this_bw,...                               % 带宽
    num,...                                   % 快照数
    config.n_UE,...                          % UE数目
    config.n_UAV,...                         % UAV数目
    type,...                           % 类型
    config.random,...
    date_time_string);

end

