function attach_MBS( config,UE,MBS )
fprintf('attach MBS...\n');
Tx_MBS = config.Tx_MBS;

for u_ = 1:length(UE)
    Pr_vector = zeros(1,length(MBS));
    for b_ = 1:length(MBS)
        d_2d = sqrt((MBS(b_).pos(1)-UE(u_).pos(1))^2+(MBS(b_).pos(2)-UE(u_).pos(2))^2);
        PL = get_MBS_PL(config,d_2d);
        PL_linear = 10^(0.1*PL);
        Pr_vector(b_) = Tx_MBS/PL_linear;
    end
    [~,index] = sort(Pr_vector);
    UE(u_).MBS_Pr = Pr_vector;
    UE(u_).attach_MBS = MBS(index(end));
    UE(u_).attach_MBS.attachUE(UE(u_));
end

for u_ = 1:length(UE)
    UE(u_).this2MBS = sqrt((UE(u_).attach_MBS.pos(1)-UE(u_).pos(1))^2+(UE(u_).attach_MBS.pos(2)-UE(u_).pos(2))^2);
end

end