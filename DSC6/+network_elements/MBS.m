classdef MBS < handle
    
    properties
        id
        pos
        attach_UE_vector
        attach_UAV_vector
        N_max
        N_kind
    end
    
    methods
        function obj = MBS
            
        end
        
        function attachUE(obj,this_UE)
            if isempty(obj.attach_UE_vector)
                obj.attach_UE_vector = this_UE;
            else
                current_UE = [obj.attach_UE_vector.id];
                if ~sum(current_UE==this_UE.id)
                    obj.attach_UE_vector = [obj.attach_UE_vector this_UE];
                end
            end
        end
        
         function deattachUE(obj,this_UE)
            if ~isempty(obj.attach_UE_vector)
                current_UE = [obj.attach_UE_vector.id];
                UE_idx = (current_UE == this_UE.id);
                UE_in_eNodeB = sum(UE_idx);
                
                if UE_in_eNodeB>0
                    obj.attach_UE_vector = obj.attach_UE_vector(~UE_idx);
                end
            end
        end
        
        function attachUAV(obj,this_UAV)
            if isempty(obj.attach_UAV_vector)
                obj.attach_UAV_vector = this_UAV;
            else
                current_UAV = [obj.attach_UAV_vector.id];
                if ~sum(current_UAV==this_UAV.id)
                    obj.attach_UAV_vector = [obj.attach_UAV_vector this_UAV];
                end
            end
        end
        
        function deattachUAV(obj,this_UAV)
            if ~isempty(obj.attach_UAV_vector)
                current_UAV = [obj.attach_UAV_vector.id];
                UAV_idx = (current_UAV == this_UAV.id);
                UAV_in_eNodeB = sum(UAV_idx);
                
                if UAV_in_eNodeB>0
                    obj.attach_UAV_vector = obj.attach_UAV_vector(~UAV_idx);
                end
            end
        end
        
    end
    
end

