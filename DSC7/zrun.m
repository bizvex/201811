clc;
clear;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
config.n_UAV = 6;
config.n_UE_per_MBS = 60;
config.random = 0;% 0:������� 1:�����������UAV
config.ACIR=20;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
config.n_hotspot_per_MBS = 2;
config.P_hotspot = 2/3;
config.ISD = 540;
config.Tx_MBS = 10^4.3/1000;
config.Tx_UAV = 10^3.3/1000;
config.frequency = 4e9;
config.bandwidth = 10e6;
config.noise_power = 10^(0.1*(-174))/1000 * config.bandwidth * 10^(5/10);
config.path = './result';

RandStream.setGlobalStream(RandStream('mt19937ar','Seed',20));

% ������վ
[ MBS,map,config ] = creat_MBS( config );
% ����UE
[ UE ] = creat_UE( config );
[ UE_pos ] = creat_UEpos( config,MBS,UE );
% ���ӻ�վ
attach_MBS( config,UE,MBS );
% ͳ�Ƽ���UAVǰ��SINR
[ UE_MBS_SINR_before ] = get_MBS_SINR_before(config,UE);
fprintf('\n');
[MBS_N_before,no_serving_before,outage_before,SE_before,SE_all_before] = caculate_before( config,UE_MBS_SINR_before,MBS,UE );
fprintf('\n');

% �㷨
loop2 = true;
while loop2% �������UAV(d_).attach_UE_vectorΪ�յ�,����UAVȫ��������һ��С��
    
    %% ����UAV�ķ���λ��
    loop2 = false;
    loop1 = true;
    while loop1% �������UAVcandidateUEΪ�յ�
        switch config.random
            case 0
                [ UAVcandidate_pos, UAVcandidateUE, UE2UAVcandidate ] = binKMeans( UE_pos, config.n_UAV,UE);
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
    
    %% ����UAV
    [ UAV ] = creat_UAV( config,UAVcandidate_pos );
    
    %% ѡ��UAV������û���UE���յ�����UAV��SINRҲ���������
    attach_UAV( config,UAV,UE,UAVcandidateUE,UE2UAVcandidate);
    for d_ = 1:length(UAV)
        if isempty(UAV(d_).attach_UE_vector)
            loop2 = true;
            break;
        end
    end
end

%  ͳ�Ƽ���UAV���SINR
[ UE_MBS_SINR_after ] = get_MBS_SINR_after(config,UE);
fprintf('\n');
[MBS_resource_after,no_serving_after,outage_after,SE_after,SE_all_after] = caculate_after( UE_MBS_SINR_after,MBS,UAV,UE );
fprintf('\n');

% ��������
plot_map( config,UE,MBS,UAV,map );
