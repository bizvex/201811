% outage 4:12
% O = [0.145499	0.145499	0.145499	0.145499	0.145499	0.145499	0.145499	0.145499	0.145499];
% A = [0.13771	0.135681	0.136746	0.137801	0.13887	0.141389	0.142154	0.14654	0.148394];
% B = [0.126542	0.126152	0.127127	0.126209	0.12486	0.13129	0.130444	0.13417	0.139179];
% C = [0.084037	0.074779	0.071828	0.071524	0.070844	0.070972	0.071742	0.073339	0.074066];
% E = [0.2066	0.2020	0.1956	0.1866	0.1781	0.1712	0.1675	0.1642	0.1620];
% x = 4:12;

% SE5 4:12
% O = [0.971754	0.971754	0.971754	0.971754	0.971754	0.971754	0.971754	0.971754	0.971754];
% A = [1.016603	1.016042	1.015913	1.013871	1.013281	1.011434	1.009798	1.007457	1.0076];
% B = [0.938453	0.924796	0.919806	0.91417	0.907568	0.900998	0.890911	0.888536	0.879927];
% C = [1.059686	1.06248	1.059479	1.055864	1.053277	1.050912	1.048398	1.045821	1.04264];
% % % % E = [0.2993	0.2463	0.2159	0.1911	0.1697	0.1536	0.1372	0.1241	0.1148];
% x = 4:12;

% outage 30:100
O = [0.008507	0.03421	0.08122	0.145499	0.208326	0.273407	0.336318	0.381876];
A = [0.004962	0.026747	0.069592	0.136746	0.205503	0.27778	0.347169	0.396692];
B = [0.008564	0.031794	0.068509	0.127127	0.184541	0.246575	0.310189	0.356501];
C = [0.0023	0.012782	0.034023	0.071828	0.114885	0.165676	0.220553	0.264745];
E = [0.0485	0.0876	0.1371	0.1956	0.2572	0.3170	0.3693	0.4111];
x = 30:10:100;

% SE5 30:100
% O = [0.974151	0.974151	0.974151	0.974151	0.974151	0.974151	0.974151	0.974151];
% A = [1.079828	1.057456	1.030727	1.015913	1.019863	1.007591	1.004804	1.003597];
% B = [1.035331	0.995806	0.949087	0.919806	0.911854	0.894992	0.881926	0.883987];
% C = [1.167996	1.122491	1.084991	1.059479	1.063754	1.044581	1.036541	1.038174];
% % % % % E = [0.3014	0.2841	0.2461	0.2159	0.1839	0.1622	0.1434	0.1339];
% x = 30:10:100;

figure;
second_axes =  axes;

ft = fittype( 'smoothingspline' );
opts = fitoptions( ft );
opts.SmoothingParam = 0.1;
[fitresult, ~] = fit( x', O', ft, opts );
y = feval(fitresult,x);
plot(second_axes,x,y,'--','DisplayName','without UAV assistance','LineWidth',1.5,'MarkerSize',15,'Color','m');%[0.9 0.7 0.1]
hold on;

ft = fittype( 'smoothingspline' );
opts = fitoptions( ft );
opts.SmoothingParam = 0.1;
[fitresult, ~] = fit( x', A', ft, opts );
y = feval(fitresult,x);
plot(second_axes,x,y,'DisplayName','scheme A','Marker','o','LineWidth',1.5,'MarkerSize',8,'Color','b');
hold on;

ft = fittype( 'smoothingspline' );
opts = fitoptions( ft );
opts.SmoothingParam = 0.1;
[fitresult, ~] = fit( x', B', ft, opts );
y = feval(fitresult,x);
plot(second_axes,x,y,'DisplayName','scheme B','Marker','d','LineWidth',1.5,'MarkerSize',8,'Color',[0.1 0.9 0]);
hold on;

ft = fittype( 'smoothingspline' );
opts = fitoptions( ft );
opts.SmoothingParam = 0.1;
[fitresult, ~] = fit( x', C', ft, opts );
y = feval(fitresult,x);
plot(second_axes,x,y,'DisplayName','scheme C','Marker','.','LineWidth',1.5,'MarkerSize',20,'Color','r');
hold on;

ft = fittype( 'smoothingspline' );
opts = fitoptions( ft );
opts.SmoothingParam = 0.1;
[fitresult, ~] = fit( x', E', ft, opts );
y = feval(fitresult,x);
plot(second_axes,x,y,'DisplayName','whitout ICIC','Marker','v','LineWidth',1.5,'MarkerSize',8,'Color',[0.8 0.5 0]);
hold on;

ylabel(second_axes,'Outage Probability');% 5th Percentile Spectral Efficiency [bps/Hz]; Outage Probability
xlabel(second_axes,'Number of UEs Per Macro Cell');% Number of UAVs;Number of UEs Per Macro Cell

legend(second_axes,'show','Location','Best');
grid on;
