function pos = spatial_in_circle(r,n,centre_pos)
pos = zeros(n,2);
u_ = 1;
while u_<=n
%     tmp_x = random('unif',centre_pos(1)-r,centre_pos(1)+r);
%     tmp_y = random('unif',centre_pos(2)-r,centre_pos(2)+r);
% 一般来说，可以使用公式 r = a + (b-a).*rand(N,1) 生成区间 (a,b) 内的 N 个随机数。
    tmp_x = centre_pos(1)-r+2*r.*rand(1);
    tmp_y = centre_pos(2)-r+2*r.*rand(1);
    if (tmp_x-centre_pos(1))^2+(tmp_y-centre_pos(2))^2 < r^2
        pos(u_,1) = tmp_x;
        pos(u_,2) = tmp_y;
        u_ = u_ + 1;
    end
end
end