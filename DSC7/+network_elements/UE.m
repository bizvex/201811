classdef UE < handle
   
    properties
        id
        pos
        D
        m_MBSpower
        m_UAVpower
        attach_MBS
        attach_UAV % 在UAV服务范围内的UE都会有这个值
        belong2UAV % 真正被UAV服务的UE这个值为true
        this2MBS
        this2UAV % UE到聚类的中心的距离
        UAV_SINR
        MBS_SINR_before
        MBS_SINR_after
    end
    
    methods
        function obj = UE
            
        end
        
        function UEget_MBS_SINR_before(obj,config)
            receive_MBS = obj.m_MBSpower;
            signal_power = receive_MBS(obj.attach_MBS.id);
            noise_power = config.noise_power;
            receive_MBS(obj.attach_MBS.id) = [];
            interference_power = sum(receive_MBS(:));
            obj.MBS_SINR_before = 10*log10(signal_power/...
                (interference_power+noise_power));
        end
        
        function get_MBS_SINR_FFRA_after(obj,config)
            receive_MBS = obj.m_MBSpower;
            signal_power = receive_MBS(obj.attach_MBS.id);
            noise_power = config.noise_power;
            receive_MBS(obj.attach_MBS.id) = [];
            MBS_interference_power = sum(receive_MBS(:));
            UAV_interference_power = sum(obj.m_UAVpower(:));
            obj.MBS_SINR_after = 10*log10(signal_power/...
                (MBS_interference_power+UAV_interference_power/invdB(config.ACIR)+noise_power));
        end
        
        function get_UAV_SINR_FFRA(obj,config,UAVid)
            receive_UAV=obj.m_UAVpower;
            signal_power = receive_UAV(UAVid);
            noise_power = config.noise_power;
            receive_UAV(UAVid) = [];
            UAV_interference_power=sum(receive_UAV(:));
            
            receive_MBS = obj.m_MBSpower;
            MBS_interference_power = sum(receive_MBS(:));
            
            obj.UAV_SINR = 10*log10(signal_power/... 
                (MBS_interference_power/invdB(config.ACIR)+UAV_interference_power+noise_power));
        end
        
    end
    
end

