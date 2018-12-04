clc;
clear;

num=200;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n_UAV = 6;
n_UE_per_MBS = 60;
ACIR=20;
config.random = 0;% 0:代表聚类 1:代表传统聚类 2:代表随机
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
config.num=num;
config.n_hotspot_per_MBS = 2;
config.P_hotspot = 2/3;
config.ISD = 540;
config.Tx_MBS = 10^4.3/1000;
config.Tx_UAV = 10^3.3/1000;
config.frequency = 4e9;
config.bandwidth = 20e6;
config.noise_power = 10^(0.1*(-174))/1000 * config.bandwidth * 10^(5/10);
config.path = './result';

if length(n_UAV)==1 && length(n_UE_per_MBS)==1 && length(ACIR)==1
    loopparm=1;
    config.n_UAV = n_UAV;
    config.n_UE_per_MBS = n_UE_per_MBS;
    config.ACIR=ACIR;
elseif length(n_UAV)~=1
    loopparm=n_UAV;
    config.n_UE_per_MBS = n_UE_per_MBS;
    config.ACIR=ACIR;
elseif length(n_UE_per_MBS)~=1
    config.n_UAV = n_UAV;
    loopparm = n_UE_per_MBS;
    config.ACIR=ACIR;
elseif length(ACIR)~=1
    config.n_UAV = n_UAV;
    config.n_UE_per_MBS = n_UE_per_MBS;
    loopparm=ACIR;
else
    error('wrong');
end

for lp=1:length(loopparm)
    if length(n_UAV)==1 && length(n_UE_per_MBS)==1 && length(ACIR)==1
        % do nothing
    elseif length(n_UAV)~=1
        fprintf('UAV数目：%d\n',loopparm(lp));
        config.n_UAV=loopparm(lp);
    elseif length(n_UE_per_MBS)~=1
        fprintf('UE数目：%d\n',loopparm(lp));
        config.n_UE_per_MBS = loopparm(lp);
    elseif length(ACIR)~=1
        fprintf('ACIR：%d\n',loopparm(lp));
        config.ACIR=loopparm(lp);
    else
        error('wrong');
    end
    
    MBS_resource_before_set = cell(1,num);
    no_serving_before_set = cell(1,num);
    outage_before_set = zeros(1,num);
    SE_before_set = zeros(1,num);
    SE_all_before_set = cell(1,num);
    MBS_resource_after_set = cell(1,num);
    no_serving_after_set = cell(1,num);
    outage_after_set = zeros(1,num);
    SE_after_set = zeros(1,num);
    SE_all_after_set = cell(1,num);
    SE_MBS_after_set=cell(1,num);
    SE_MBS_all_after_set=cell(1,num);
    m_PLOS_set=cell(1,num);
    for i = 1:num
        RandStream.setGlobalStream(RandStream('mt19937ar','Seed',i));% UAV6 UE60 用第20个snapshot好像还可以
        fprintf('snapshot %d\n\n',i);
        
        % 产生基站
        [ MBS,map,config ] = creat_MBS( config );
        % 产生UE
        [ UE ] = creat_UE( config );
        [ UE_pos ] = creat_UEpos( config,MBS,UE );
        % 连接基站
        attach_MBS( config,UE,MBS );
        % 统计加入UAV前的SINR
        [ UE_MBS_SINR_before ] = get_MBS_SINR_before(config,UE);
        fprintf('\n');
        [MBS_resource_before,no_serving_before,outage_before,SE_before,SE_all_before] = caculate_before( config,UE_MBS_SINR_before,MBS,UE );
        fprintf('\n');
        
        % 算法
        loop2 = true;
        while loop2% 避免产生UAV(d_).attach_UE_vector为空的,避免UAV全部集中在一个小区
            
            %% 产生UAV的放置位置
            loop2 = false;
            loop1 = true;
            while loop1% 避免产生UAVcandidateUE为空的
                switch config.random
                    case 0
                        [ UAVcandidate_pos, UAVcandidateUE, UE2UAVcandidate ] = binKMeans(config, UE_pos, config.n_UAV,UE);
                    case 1
                        [ UAVcandidate_pos, UAVcandidateUE, UE2UAVcandidate ] = binKMeans2(UE_pos,config.n_UAV);
                    case 2
                        [ UAVcandidate_pos, UAVcandidateUE, UE2UAVcandidate ] = get_UAVcandidate_pos_random( config,UE_pos,UE );
                end
                loop1 = false;
                for g = 1:length(UAVcandidateUE)
                    if isempty(UAVcandidateUE{g})
                        loop1 = true;
                        break;
                    end
                end
            end
            
            %% 产生UAV
            [ UAV ] = creat_UAV( config,UAVcandidate_pos );
            
            %% 选择UAV服务的用户，UE接收到来自UAV的SINR也在这里计算
            [ m_PLOS ]=attach_UAV( config,UAV,UE,UAVcandidateUE,UE2UAVcandidate);
%             for d_ = 1:length(UAV)
%                 if isempty(UAV(d_).attach_UE_vector)
%                     loop2 = true;
%                     break;
%                 end
%             end
        end
        
        %  统计加入UAV后的SINR
        [ UE_MBS_SINR_after ] = get_MBS_SINR_after(config,UE);
        fprintf('\n');
        [MBS_resource_after,no_serving_after,outage_after,SE_after,SE_all_after,SE_MBS_after,SE_MBS_all_after] = caculate_after( UE_MBS_SINR_after,MBS,UAV,UE );
        fprintf('\n');
        % 保存数据
        MBS_resource_before_set{i} = MBS_resource_before;
        no_serving_before_set{i} = no_serving_before;
        outage_before_set(i) = outage_before;
        SE_before_set(i) = SE_before;
        SE_all_before_set{i} = SE_all_before;
        MBS_resource_after_set{i} = MBS_resource_after;
        no_serving_after_set{i} = no_serving_after;
        outage_after_set(i) = outage_after;
        SE_after_set(i) = SE_after;
        SE_all_after_set{i} = SE_all_after;
        SE_MBS_after_set{i}=SE_MBS_after;
        SE_MBS_all_after_set{i}=SE_MBS_all_after;
        m_PLOS_set{i}=m_PLOS;
    end
    
    % 网络拓扑
    if num==1
        plot_map( config,UE,MBS,UAV,map );
    end
    
    % 存入result
    [ results_filename ] = gen_file_name( config,num );save(fullfile(config.path,results_filename),'MBS_resource_before_set','no_serving_before_set',...
        'outage_before_set','SE_before_set','SE_all_before_set','MBS_resource_after_set','no_serving_after_set','outage_after_set',...
        'SE_after_set','SE_all_after_set','SE_MBS_after_set','SE_MBS_all_after_set','m_PLOS_set');
end
