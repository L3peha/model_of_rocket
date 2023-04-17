function [P] = ePrecession(tau)
%ePrecession Рассчет митрицы прецессии Земли

zeta_a = 0.0111808609*tau + 0.146356*10.^(-5)*tau.^2 + 0.872*10.^(-7)*tau.^3;
z_a = 0.0111808609*tau + 0.53072*10.^(-5)*tau.^2 + 0.883*10.^(-7)*tau.^3;
thetta_a = 0.0097171735*tau - 0.20685*10.^(-5)*tau.^2 - 0.2028*10.^(-6)*tau.^3;

P = eye(3);
P(1,1) = cos(zeta_a)*cos(z_a)*cos(thetta_a) - sin(zeta_a)*sin(z_a);
P(1,2) = -sin(zeta_a)*cos(z_a)*cos(thetta_a) - cos(zeta_a)*sin(z_a);
P(1,3) = -cos(z_a)*sin(thetta_a);
P(2,1) = cos(zeta_a)*sin(z_a)*cos(thetta_a) + sin(zeta_a)*cos(z_a);
P(2,2) = -sin(zeta_a)*sin(z_a)*cos(thetta_a) + cos(zeta_a)*cos(z_a);
P(2,3) = -sin(z_a)*sin(thetta_a);
P(3,1) = cos(zeta_a)*sin(thetta_a);
P(3,2) = -sin(zeta_a)*sin(thetta_a);
P(3,3) = cos(thetta_a);

end