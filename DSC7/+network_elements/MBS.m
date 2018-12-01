classdef MBS < handle
    
    properties
        id
        pos
        attach_UE_vector
        resource
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
        
    end
    
end

