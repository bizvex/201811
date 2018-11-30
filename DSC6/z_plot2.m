

%outage 4:12 C
% C0 = [0.084037	0.074779	0.071828	0.071524	0.070844	0.070972	0.071742	0.073339	0.074066];
% C1 = [0.079845	0.084868	0.085838	0.084293	0.083115	0.082839	0.08206	0.083196	0.080957];
% C2 = [0.120797	0.116016	0.110127	0.108417	0.106558	0.104234	0.103598	0.102989	0.101925];
% x = 4:12;

% outage 30:100 C
C0 = [0.0023	0.012782	0.034023	0.071828	0.114885	0.165676	0.220553	0.264745];
C1 = [0.002101	0.014008	0.039145	0.085838	0.133667	0.186441	0.242262	0.285284];
C2 = [0.005893	0.025135	0.061049	0.110127	0.158593	0.211174	0.266267	0.300026];
x = 30:10:100;

figure;
second_axes =  axes;

ft = fittype( 'smoothingspline' );
opts = fitoptions( ft );
opts.SmoothingParam = 0.1;
[fitresult, ~] = fit( x', C0', ft, opts );
y = feval(fitresult,x);
plot(second_axes,x,y,'DisplayName','proposed bisecting K-means','Marker','.','LineWidth',1.5,'MarkerSize',20,'Color','r');
hold on;

ft = fittype( 'smoothingspline' );
opts = fitoptions( ft );
opts.SmoothingParam = 0.1;
[fitresult, ~] = fit( x', C1', ft, opts );
y = feval(fitresult,x);
plot(second_axes,x,y,'DisplayName','traditional bisecting K-means','Marker','^','LineWidth',1.5,'MarkerSize',8,'Color','r');
hold on;

ft = fittype( 'smoothingspline' );
opts = fitoptions( ft );
opts.SmoothingParam = 0.1;
[fitresult, ~] = fit( x', C2', ft, opts );
y = feval(fitresult,x);
plot(second_axes,x,y,'DisplayName','randomly deployment','Marker','s','LineWidth',1.5,'MarkerSize',8,'Color','r');
hold on;



ylabel(second_axes,'Outage Probability');% Spectral Efficiency; Outage Probability
xlabel(second_axes,'Number of UEs Per Macro Cell');% Number of UAVs;Number of UEs Per Macro Cell

legend(second_axes,'show','Location','Best');
grid on;
