%% 2D天线
% clear;
% x=-180:0.1:180;
% az=deg2rad(x);
% phi3dB=deg2rad(65);
% az=az/phi3dB;
% Am=30;
% gain=max(-12*az.*az,-Am*ones(size(az)));
% plot(x,gain,'LineWidth',4,'Color','r');
% xlabel('水平面夹角 [度]');
% ylabel('天线增益 [dB]');
% grid on;

%% 3D天线
clear;
x=-180:3:180;
y=0:3:180;
az=deg2rad(x);
el=deg2rad(y);
Nh=2;
Nv=2;
wavelength=3e8/4e9;
Dh=0.5/1;
Dv=0.8/1;
Am=30;
SLAv=30;
phi3dB=deg2rad(65);
theta3dB=deg2rad(65);
res=zeros(length(x),length(y));
az_target=deg2rad(0);
el_targt=deg2rad(0);
for i=1:length(az)
    for j=1:length(el)
        a=(az(i)-az_target)/phi3dB;
        azgain=max(-12*a*a,-Am);
        e=(el(j)-el_targt-pi/2)/theta3dB;
        elgain=max(-12*e*e,-SLAv);
        gain=max(azgain+elgain,-Am);
        sum=0;
        for m=0:Nh-1
            for n=0:Nv-1
                v=exp(2j*pi*(n*Dv*cos(el(j))+m*Dh*sin(el(j))*sin(az(i))));
                w=1/sqrt(Nh*Nv)*exp(2j*pi*(n*Dv*sin(el_targt)-m*Dh*cos(el_targt)*sin(az_target)));
                sum=sum+v*w;
            end
        end
        arraygain=10*log10(power(abs(sum),2));
        if el(j)==el_targt+deg2rad(90)&&az(i)==az_target
            arraygain
        end
        %res(i,j)=max(arraygain,-Am);
        res(i,j)=max(arraygain+gain,-Am);
    end
end
[x,y]=meshgrid(x,y);
mesh(x,y,res');
xlabel('水平方向 [度]');
ylabel('垂直方向 [度]');
zlabel('天线增益 [dB]');
