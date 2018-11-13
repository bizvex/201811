function plotsmooth( axes,x,y,displayname,linewidth,current_marker_color )
ft = fittype( 'smoothingspline' );
opts = fitoptions( ft );
opts.SmoothingParam = 0.1;
[fitresult, ~] = fit( x', y', ft, opts );
x = min(x):max(x);
y = feval(fitresult,x);
y(y<0) = 0;
y(y>1)=1;
plot(axes,x,y,'DisplayName',displayname,'LineWidth',linewidth,'Color',current_marker_color);
end

