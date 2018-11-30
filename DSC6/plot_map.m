function plot_map( config,UE,MBS,UAV,map )

UE_pos_vector = zeros(length(UE),2);
MBS_pos_vector = zeros(length(MBS),2);
UAV_pos_vector = zeros(length(UAV),2);
for u_ = 1:length(UE)
    UE_pos_vector(u_,:) = UE(u_).pos;
end
for b_ = 1:length(MBS)
    MBS_pos_vector(b_,:) = MBS(b_).pos;
end
for d_ = 1:length(UAV)
    UAV_pos_vector(d_,:) = UAV(d_).pos;
end

figure;

% »ùÕ¾Á´½ÓÏß
for u_ = 1:length(UE)
    if UE(u_).belong2UAV
        line([UE(u_).pos(1),UE(u_).attach_UAV.pos(1)],[UE(u_).pos(2),UE(u_).attach_UAV.pos(2)],'color','m');
        hold on;
    else
        line([UE(u_).pos(1),UE(u_).attach_MBS.pos(1)],[UE(u_).pos(2),UE(u_).attach_MBS.pos(2)],'color','y');
        hold on;
    end
end

for u_ = 1:length(UE)
    if UE(u_).belong2UAV
        scatter(UE(u_).pos(1),UE(u_).pos(2),'.c');
        hold on;
    else
        scatter(UE(u_).pos(1),UE(u_).pos(2),'.b');
        hold on;
    end
%     text(UE(u_).pos(1),UE(u_).pos(2),num2str(UE(u_).id));
end
scatter(MBS_pos_vector(:,1)',MBS_pos_vector(:,2)',500,'.r');
hold on;
scatter(UAV_pos_vector(:,1)',UAV_pos_vector(:,2)',500,'.k');
hold on;
for d_ = 1:length(UAV)
    if UAV(d_).isUse
        scatter(UAV_pos_vector(d_,1)',UAV_pos_vector(d_,2)',500,'.g');
%         plot_circle(UAV_pos_vector(d_,:),UAV(d_).r);
    end
    text(UAV_pos_vector(d_,1),UAV_pos_vector(d_,2),num2str(d_));
end
for b_ = 1:length(MBS)
    text(MBS_pos_vector(b_,1),MBS_pos_vector(b_,2),num2str(b_));
    ISD = config.ISD;
    cell_r = ISD*(3^0.5)/3;
%     plot_circle(MBS_pos_vector(b_,:),cell_r);
end

axis([map(1,1),map(1,2),map(2,1),map(2,2)]);

end

function plot_circle(pos,r)
theta=0:0.1:2*pi;
x = pos(1)+r*cos(theta);  
y = pos(2)+r*sin(theta); 
plot(x,y,'r');
hold on;
end

