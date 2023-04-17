function [vSun] = sunPos(tau)
%sunPos Вычисление вектора направления на Солнце

Ms = 6.24003594 + 628.30195602*tau - 2.7974*10^-6*tau^2 - 5.82*10^-8*tau^3;

lambdaS_mean = 4.8950563519 + tau*(628.33196621395+5.279621*10.^(-6)*tau);
p = tau*(2.4381748353*10.^(-4) + 5.386910254912387*10.^(-8)*tau);
deltaLambdaS = 0.033502079546*sin(Ms) + 0.00035074667539*sin(2*Ms) + ...
    5.235987756*10.^(-6)*sin(3*Ms);

Ms = (0.5*Ms/pi - floor(0.5*Ms/pi))*2*pi;
lambdaS_mean = (0.5*lambdaS_mean/pi - floor(0.5*lambdaS_mean/pi))*2*pi;
lambdaS = lambdaS_mean + deltaLambdaS + p;

e = 0.016708617 - 0.000042037*tau - 0.0000001236*tau^2;

rS = 1.00000100178*149597870.7*(1 + 0.5*e.^2 - e*cos(Ms) - 0.5*e.^2*cos(2*Ms));


N = eNutation(tau);
Nf = -acos(N(1,1))*sign(N(1,2));
cos_eps = N(2,1)/sin(Nf);
sin_eps = N(3,1)/sin(Nf);

vSun =  [cos(lambdaS) sin(lambdaS)*cos_eps sin(lambdaS)*sin_eps]';
end