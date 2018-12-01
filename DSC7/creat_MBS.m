function [ MBS,map,config ] = creat_MBS( config )

fprintf('MBS...\n');

n_rings = 1;
ISD = config.ISD;% 基站间距离

[tmp_gridx,tmp_gridy] = meshgrid(-n_rings:n_rings,(-n_rings:n_rings)*sin(pi/3));
if mod(n_rings,2) == 0
    tmp_shift_idx = 2:2:2*n_rings+1; %转换偶数列
else
    tmp_shift_idx = 1:2:2*n_rings+1; %转换奇数列
end
tmp_gridx(tmp_shift_idx,:) = tmp_gridx(tmp_shift_idx,:) + 0.5;%转换

rot = @(w_) [cos(w_),-sin(w_);sin(w_),cos(w_)]; %rot是一个函数，w_是其输入参数，函数的作用是产生一个矩阵
for i_ = 1:7
    tmp_hex(i_,:) = ((n_rings+0.5)*rot(pi/3)^(i_-1)*[1;0]).'; % 乘[1;0]表示只取第一列
end

tmp_valid_positions = inpolygon(tmp_gridx,tmp_gridy,tmp_hex(:,1),tmp_hex(:,2));% tmp_hex是正六边形顶点坐标，inpolygon判断点是否在六边形内
tmp_x = tmp_gridx(tmp_valid_positions);
tmp_y = tmp_gridy(tmp_valid_positions);

for b_ = 1:length(tmp_x);
    MBS(b_)           = network_elements.MBS;
    MBS(b_).id        = b_;
    MBS(b_).pos       = [tmp_x(b_)*ISD tmp_y(b_)*ISD];
    MBS(b_).resource  = config.bandwidth;
end

config.n_MBS=length(MBS);

tx_pos = zeros(length(MBS),2);%2列，第一列为x，第二列为y
for b_ = 1:length(MBS)
    tx_pos(b_,:) = MBS(b_).pos;
end

roi_x = [min(tx_pos(:,1)),max(tx_pos(:,1))];
roi_y = [min(tx_pos(:,2)),max(tx_pos(:,2))];
roi_x =[roi_x(1)-2*ISD/3 roi_x(2)+2*ISD/3];
roi_y =[roi_y(1)-2*ISD/3 roi_y(2)+2*ISD/3];

map = [roi_x;roi_y];

end

