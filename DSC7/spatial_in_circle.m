function pos = spatial_in_circle(r,n,centre_pos)
pos = zeros(n,2);
u_ = 1;
while u_<=n
    tmp_x = random('unif',centre_pos(1)-r,centre_pos(1)+r);
    tmp_y = random('unif',centre_pos(2)-r,centre_pos(2)+r);
    if (tmp_x-centre_pos(1))^2+(tmp_y-centre_pos(2))^2 < r^2
        pos(u_,1) = tmp_x;
        pos(u_,2) = tmp_y;
        u_ = u_ + 1;
    end
end
end