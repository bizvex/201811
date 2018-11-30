function [ use_UAV_index ] = select_UAV( config,UE,MBS,UAV,UAVcandidate_pos )
fprintf('select UAV...\n');

% use_UAV_index = [];
% for k_ = 1:config.n_UAV
%     remain_hotspot = 1:length(UAVcandidate_pos);
%     if ~isempty(use_UAV_index)
%         [~,ia,~] = intersect(remain_hotspot,use_UAV_index);
%         remain_hotspot(ia) = [];
%     end
%     
%     SINR_vector = zeros(1,length(remain_hotspot));
%     for d_ = 1:length(remain_hotspot)
%         SINR_vector(d_) = select_UAV_tmp(config,UE,MBS,UAV,use_UAV_index,remain_hotspot(d_));
%     end
%     [~,index] = sort(SINR_vector);
%     use_index = remain_hotspot(index(end));
%     if isempty(use_UAV_index)
%         use_UAV_index = use_index;
%     else
%         use_UAV_index = [use_UAV_index,use_index];
%     end
%     
% end

use_UAV_index = 1:config.n_UAV;
use_UAV_index = sort(use_UAV_index);
for d_ = 1:length(use_UAV_index)
    UAV(use_UAV_index(d_)).isUse = true;
    attach_UE_vector = UAV(use_UAV_index(d_)).attach_UE_vector;
    for u_ = 1:length(attach_UE_vector)
        attach_UE_vector(u_).belong2UAV = true;
        % UE从MBS卸下
        attach_UE_vector(u_).attach_MBS.deattachUE(attach_UE_vector(u_));
    end
end

% 这步实际没有用，因为use_UAV_index = 1:length(UAV)
no_ues_UAV_index = 1:length(UAV);
[~,ia,~] = intersect(no_ues_UAV_index,use_UAV_index);
no_ues_UAV_index(ia) = [];
for d_ = 1:length(no_ues_UAV_index)
    UAV(no_ues_UAV_index(d_)).attach_MBS.deattachUAV(UAV(no_ues_UAV_index(d_)));% UAV从MBS卸下
end

end
%%%%%%%%% 下面没用到 %%%%%%%%%%
function SINR = select_UAV_tmp(config,UE,MBS,UAV,use_UAV_index,varargin)

if length(varargin)<1
    % 若length(varargin)<1，use_UAV_index不会为空
else
    if isempty(use_UAV_index)
        use_UAV_index = varargin{1};
    else
        use_UAV_index = [use_UAV_index,varargin{1}];
    end
end
SINR = get_SINR_tmp(config,UE,MBS,UAV,use_UAV_index);% 将该UAV加入选择


end

function SINR = get_SINR_tmp(config,UE,MBS,UAV,use_UAV_index)

UE_MBS_SINR = 0;
UE_UAV_SINR = 0;
UAV_UE_id = [];% 全部UE中被UAV服务的UE
if ~isempty(use_UAV_index)
    for d_ = 1:length(use_UAV_index)
        if isempty(UAV_UE_id)
            UAV_UE_id = [UAV(use_UAV_index(d_)).attach_UE_vector.id];
        else
            tmp = [UAV(use_UAV_index(d_)).attach_UE_vector.id];
            UAV_UE_id = [UAV_UE_id,tmp];
        end
    end
    all_UE_id = 1:length(UE);
    [~,ia,~] = intersect(all_UE_id,UAV_UE_id);
    all_UE_id(ia) = [];
    no_UAV_UE_id = all_UE_id;% 全部UE中不被UAV服务的UE
    
end

% 确定资源分配状况
for d_ = 1:length(use_UAV_index)
    UAV(use_UAV_index(d_)).N_kind = d_;
end
for b_ = 1:length(MBS)
    switch config.type
        case 'FFRA'
            MBS(b_).N_kind = 0;% FFRA
        case {'FFRB','FFRC'}
            cell_N_kind = 1:config.n_UAV;
            if ~isempty(MBS(b_).attach_UAV_vector)
                UVA_N_kind = [MBS(b_).attach_UAV_vector.N_kind];
                [~,ia,~] = intersect(cell_N_kind,UVA_N_kind);
                cell_N_kind(ia) = [];
            end
            MBS(b_).N_kind = cell_N_kind;
    end
end

for u_ = 1:length(no_UAV_UE_id)
    switch config.type
        case 'FFRA'
            UE(no_UAV_UE_id(u_)).UAV_Pr = 0;% FFRA中MBS的UE不受UAV干扰
            UE(no_UAV_UE_id(u_)).get_MBS_SINR_FFRA_after(config);
            UE_MBS_SINR = UE_MBS_SINR+UE(no_UAV_UE_id(u_)).MBS_SINR_after;
        case 'FFRB'
            if ~isempty(use_UAV_index)
                cell_N_kind = MBS(UE(no_UAV_UE_id(u_)).attach_MBS.id).N_kind;
                thisUE_N_kind = cell_N_kind(randperm(length(cell_N_kind),1));% 若UAV都集中在了某个小区，导致MBS无法给不是UAV服务的UE提供资源就会出错
                Pr_vector = zeros(1,length(use_UAV_index));
                for d_ = 1:length(use_UAV_index)
                    if thisUE_N_kind == UAV(use_UAV_index(d_)).N_kind
                        d_2_UAV = sqrt((UE(no_UAV_UE_id(u_)).pos(1)-UAV(use_UAV_index(d_)).pos(1))^2+(UE(no_UAV_UE_id(u_)).pos(2)-UAV(use_UAV_index(d_)).pos(2))^2);
                        PL = get_UAV_PL( config,d_2_UAV,UAV(use_UAV_index(d_)).h );
                        PL_linear = 10^(0.1*PL);
                        Tx_UAV = config.Tx_UAV;
                        Pr_vector(d_) = Tx_UAV/PL_linear;
                    else
                        Pr_vector(d_) = 0;
                    end
                end
                UE(no_UAV_UE_id(u_)).UAV_Pr = Pr_vector;
                UE(no_UAV_UE_id(u_)).get_MBS_SINR_FFRB_after(config,UAV(use_UAV_index));
                UE_MBS_SINR = UE_MBS_SINR+UE(no_UAV_UE_id(u_)).MBS_SINR_after;
            else
                UE(no_UAV_UE_id(u_)).UAV_Pr = 0;
                UE(no_UAV_UE_id(u_)).get_MBS_SINR_FFRB_after(config,UAV(use_UAV_index));
                UE_MBS_SINR = UE_MBS_SINR+UE(no_UAV_UE_id(u_)).MBS_SINR_after;
            end
        case 'FFRC'
            if ~isempty(use_UAV_index)
                cell_N_kind = MBS(UE(no_UAV_UE_id(u_)).attach_MBS.id).N_kind;
                thisUE_N_kind = cell_N_kind(randperm(length(cell_N_kind),1));% 若UAV都集中在了某个小区，导致MBS无法给不是UAV服务的UE提供资源就会出错
                Pr_vector = zeros(1,length(use_UAV_index));
                for d_ = 1:length(use_UAV_index)
                    if thisUE_N_kind == UAV(use_UAV_index(d_)).N_kind
                        d_2_UAV = sqrt((UE(no_UAV_UE_id(u_)).pos(1)-UAV(use_UAV_index(d_)).pos(1))^2+(UE(no_UAV_UE_id(u_)).pos(2)-UAV(use_UAV_index(d_)).pos(2))^2);
                        PL = get_UAV_PL( config,d_2_UAV,UAV(use_UAV_index(d_)).h );
                        PL_linear = 10^(0.1*PL);
                        Tx_UAV = config.Tx_UAV;
                        Pr_vector(d_) = Tx_UAV/PL_linear;
                    else
                        Pr_vector(d_) = 0;
                    end
                end
                UE(no_UAV_UE_id(u_)).UAV_Pr = Pr_vector;
                UE(no_UAV_UE_id(u_)).get_MBS_SINR_FFRC_after(config,UAV(use_UAV_index));
                UE_MBS_SINR = UE_MBS_SINR+UE(no_UAV_UE_id(u_)).MBS_SINR_after;
            else
                UE(no_UAV_UE_id(u_)).UAV_Pr = 0;
                UE(no_UAV_UE_id(u_)).get_MBS_SINR_FFRC_after(config,UAV(use_UAV_index));
                UE_MBS_SINR = UE_MBS_SINR+UE(no_UAV_UE_id(u_)).MBS_SINR_after;
            end
    end
end

for u_ = 1:length(UAV_UE_id)
    UE_UAV_SINR = UE_UAV_SINR+UE(UAV_UE_id(u_)).UAV_SINR;
end

SINR = UE_MBS_SINR+UE_UAV_SINR;

end


