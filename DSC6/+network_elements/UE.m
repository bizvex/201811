classdef UE < handle
   
    properties
        id
        pos
        D
        N_kind
        MBS_Pr
        UAV_Pr
        attach_MBS
        attach_UAV % 在UAV服务范围内的UE都会有这个值
        belong2UAV % 真正被UAV服务的UE这个值为true
        this2MBS
        this2UAV % UE到聚类的中心的距离
        F1
        request_UAV_handover
        UAV_SINR
        MBS_SINR_before
        MBS_SINR_after
        
        % 波束
        MBS_ser_BF
        MBS_in_BF
        UAV_ser_BF
        UAV_in_BF
    end
    
    methods
        function obj = UE
            
        end
        
        function get_MBS_SINR_before(obj,config)
            receive_MBS = obj.MBS_Pr;
            signal_power = receive_MBS(obj.attach_MBS.id);
            noise_power = config.noise_power;
            receive_MBS(obj.attach_MBS.id) = [];
            interference_power = sum(receive_MBS(:));
            obj.MBS_SINR_before = 10*log10(signal_power*invdB(obj.MBS_ser_BF)/(interference_power+noise_power));
        end
        
        function get_MBS_SINR_FFRA_after(obj,config)
            receive_MBS = obj.MBS_Pr;
            signal_power = receive_MBS(obj.attach_MBS.id);
            noise_power = config.noise_power;
            receive_MBS(obj.attach_MBS.id) = [];
            MBS_interference_power = sum(receive_MBS(:));
            UAV_interference_power = sum(obj.UAV_Pr(:));
            obj.MBS_SINR_after = 10*log10(signal_power*invdB(obj.MBS_ser_BF)/(MBS_interference_power+UAV_interference_power*invdB(obj.UAV_in_BF)+noise_power));
        end
        
        function get_UAV_SINR_FFRA(obj,config,d_2d,this_UAV)
            PL = get_UAV_PL( config,d_2d,this_UAV.h );
            PL_linear = 10^(0.1*PL);
            Tx_UAV = config.Tx_UAV;
            noise_power = config.noise_power;
            signal_power = Tx_UAV/PL_linear;
            
            receive_MBS = obj.MBS_Pr;
            MBS_interference_power = sum(receive_MBS(:));
            
            obj.UAV_SINR = 10*log10(signal_power*invdB(obj.UAV_ser_BF)/ (MBS_interference_power*invdB(obj.MBS_in_BF)+noise_power));
        end
        
    end
    
end

