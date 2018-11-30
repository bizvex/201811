clc;
clear;

num = 0; % 从0开始

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n_UAV = 6;
n_UE_per_MBS = 60;% Configuration #4b 
type = {'FFRA'};% FFRA,FFRB,FFRC,FFRD,FFRE
config.random = 0;% 0:代表聚类 1:代表随机放置UAV
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

config.n_hotspot_per_MBS = 2;
config.P_hotspot = 2/3;
config.ISD = 540;
config.Tx_MBS = 10^4.3/1000;
config.Tx_UAV = 10^3.3/1000;
config.frequency = 4e9;
config.bandwidth = 20e6;
config.noise_power = 10^(0.1*(-174))/1000 * config.bandwidth * 10^(5/10);
config.path = './result';

config.a = 0.5;%A 中UAV使用的资源比例
config.c = 0.1;

if length(n_UAV)~=1 && length(n_UE_per_MBS)==1 && length(type) == 1
    xx = n_UAV;
    config.n_UE_per_MBS = n_UE_per_MBS;
    config.type = type{1};
elseif length(n_UAV)==1 && length(n_UE_per_MBS)~=1 && length(type) == 1
    xx = n_UE_per_MBS;
    config.n_UAV = n_UAV;
    config.type = type{1};
elseif length(n_UAV)==1 && length(n_UE_per_MBS)==1 && length(type) ~= 1
    xx = type;
    config.n_UAV = n_UAV;
    config.n_UE_per_MBS = n_UE_per_MBS;
elseif length(n_UAV)==1 && length(n_UE_per_MBS)==1 && length(type) == 1
    xx={'正常'};
    config.n_UAV = n_UAV;
    config.n_UE_per_MBS = n_UE_per_MBS;
    config.type = type{1};
else
    error('error');
end

for yy = 1:length(xx)
    if length(n_UAV)~=1 && length(n_UE_per_MBS)==1 && length(type) == 1
        fprintf('UAV数目：%d\n',xx(yy));
        config.n_UAV = xx(yy);
    elseif length(n_UAV)==1 && length(n_UE_per_MBS)~=1 && length(type) == 1
        fprintf('UE数目：%d\n',xx(yy));
        config.n_UE_per_MBS = xx(yy);
    elseif length(n_UAV)==1 && length(n_UE_per_MBS)==1 && length(type) ~= 1
        fprintf('类型：%s\n',xx{yy});
        config.type = xx{yy};
    elseif length(n_UAV)==1 && length(n_UE_per_MBS)==1 && length(type) == 1
        fprintf([xx{1} '\n']);
    else
        error('error');
    end

    MBS_N_before_set = cell(1,num+1);
    no_serving_before_set = cell(1,num+1);
    outage_before_set = zeros(1,num+1);
    SE_before_set = zeros(1,num+1);
    MBS_N_after_set = cell(1,num+1);
    no_serving_after_set = cell(1,num+1);
    outage_after_set = zeros(1,num+1);
    SE_after_set = zeros(1,num+1);
    SE_all_before_set = cell(1,num+1);
    SE_all_after_set = cell(1,num+1);
    
    for i = 0:num
        config.n_UAVcandidate = config.n_UAV;
        RandStream.setGlobalStream(RandStream('mt19937ar','Seed',20));% 5 60 FFRC 0 用第20个snapshot好像还可以
        fprintf('snapshot %d\n\n',i);
        
        [ MBS,map ] = creat_MBS( config );
        config.n_UE = config.n_UE_per_MBS*length(MBS);
        [ UE ] = creat_UE( config );
        [ UE_pos, extra ] = creat_UEpos( config,MBS,UE );
        attach_MBS( config,UE,MBS );
        [ UE_MBS_SINR_before ] = get_my_MBS_SINR_before(config,UE);
        
        fprintf('\n');
        [MBS_N_before,no_serving_before,outage_before,SE_before,SE_all_before] = caculate_before( config,UE_MBS_SINR_before,MBS,UE );
        fprintf('\n');
        
        UE2MBS = [UE.this2MBS];
        extra.UE2MBS = UE2MBS/extra.map_r;% 归一化
        UE_D = [UE.D]';
        extra.UE_D = (UE_D-min(UE_D))/(max(UE_D)-min(UE_D));% 归一化
        
        loop2 = true;
        while loop2% 避免产生UAV(d_).attach_UE_vector为空的,避免UAV全部集中在一个小区
            for b_ = 1:length(MBS)
                MBS(b_).attach_UAV_vector = [];
            end
    
            loop2 = false;
            loop1 = true;
            while loop1% 避免产生UAVcandidateUE为空的
                switch config.random
                    case 0
                        [ UAVcandidate_pos, UAVcandidateUE, UE2UAVcandidate ] = binKMeans( UE_pos, config.n_UAVcandidate, UE2MBS, MBS);
                    case 1
                        [ UAVcandidate_pos, UAVcandidateUE, UE2UAVcandidate ] = get_UAVcandidate_pos_random( config,UE_pos,UE2MBS );
                end
                loop1 = false;
                for g = 1:length(UAVcandidateUE)
                    if isempty(UAVcandidateUE{g})
                        loop1 = true;
                        break;
                    end
                end
            end
            [ UAV ] = creat_UAV( config,UAVcandidate_pos,MBS );
            for b_ = 1:length(MBS)
                if length(MBS(b_).attach_UAV_vector) == config.n_UAV
                    loop2 = true;
                    break;
                end
            end
            select_UE( config,UAV,UE,extra,UAVcandidateUE,UE2UAVcandidate);
            for d_ = 1:length(UAV)
                if isempty(UAV(d_).attach_UE_vector)
                    loop2 = true;
                    break;
                end
            end
        end
        [ use_UAV_index ] = select_UAV( config,UE,MBS,UAV,UAVcandidate_pos );
        update_N_kind(config,MBS,UAV,UE,use_UAV_index );
        [ UE_MBS_SINR_after ] = get_MBS_SINR_after(config,UAV,UE,use_UAV_index);
        
        fprintf('\n');
        [MBS_N_after,no_serving_after,outage_after,SE_after,SE_all_after] = caculate_after( config,UE_MBS_SINR_before,UE_MBS_SINR_after,MBS,UAV,UE );
        fprintf('\n');
        
        MBS_N_before_set{i+1} = MBS_N_before;
        no_serving_before_set{i+1} = no_serving_before;
        outage_before_set(i+1) = outage_before;
        SE_before_set(i+1) = SE_before;
        MBS_N_after_set{i+1} = MBS_N_after;
        no_serving_after_set{i+1} = no_serving_after;
        outage_after_set(i+1) = outage_after;
        SE_after_set(i+1) = SE_after;
        SE_all_before_set{i+1} = SE_all_before;
        SE_all_after_set{i+1} = SE_all_after;
        
    end
    
    if length(SE_after_set) == 1
        plot_map( config,UE,MBS,UAV,map );
    end
    
    [ results_filename ] = gen_file_name( config,num );
    save(fullfile(config.path,results_filename),'MBS_N_before_set','no_serving_before_set','outage_before_set','SE_before_set','MBS_N_after_set','no_serving_after_set','outage_after_set','SE_after_set','SE_all_before_set','SE_all_after_set');
end
