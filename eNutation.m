function [N,Na] = eNutation(tau)
%eNutation Рассчет матрицы нутации Земли

Mm = 2.355548393 + 8328.69142288*tau + 1.517952*10^-4*tau^2 + 3.103*10^-7*tau^3;
Ms = 6.24003594 + 628.30195602*tau - 2.7974*10^-6*tau^2 - 5.82*10^-8*tau^3;
Fm = 1.62790193 + 8433.46615831*tau - 6.42717*10^-5*tau^2 + 5.33*10^-8*tau^3;
Ds = 5.19846951 + 7771.37714617*tau - 3.34085*10^-5*tau^2 + 9.21*10^-8*tau^3;
Om = 2.182438624 - 33.757045936*tau + 3.61429*10^-5*tau^2 + 3.88*10^-8*tau^3;

N_fi = -0.83386*10.^(-4)*sin(Om) + 0.9997*10.^(-6)*sin(2*Om) - ...
    0.63932*10.^(-5)*sin(2*(Fm-Ds+Om)) + 0.6913*10.^(-6)*sin(Ms) - ...
    0.11024*10.^(-5)*sin(2*(Fm+Om));
N_eps = 0.44615*10.^(-4)*cos(Om) +  0.27809*10.^(-5)*cos(2*(Fm-Ds+Om)) + ...
    0.474*10.^(-6)*cos(2*(Fm+Om));
epsilon0 = 0.4090928042 - 0.2269655*10.^(-3)*tau - ...
    0.29*10.^(-8)*tau.^2 + 0.88*10.^(-8)*tau.^3;
epsilon = epsilon0 + N_eps;
N  = eye(3);
N(1,1) = cos(N_fi);
N(1,2) = -sin(N_fi)*cos(epsilon0);
N(1,3) = -sin(N_fi)*sin(epsilon0);
N(2,1) = sin(N_fi)*cos(epsilon);
N(2,2) = cos(N_fi)*cos(epsilon)*cos(epsilon0) + sin(epsilon)*sin(epsilon0);
N(2,3) = cos(N_fi)*cos(epsilon)*sin(epsilon0) - sin(epsilon)*cos(epsilon0);
N(3,1) = sin(N_fi)*sin(epsilon);
N(3,2) = cos(N_fi)*sin(epsilon)*cos(epsilon0) - cos(epsilon)*sin(epsilon0);
N(3,3) = cos(N_fi)*sin(epsilon)*sin(epsilon0) + cos(epsilon)*cos(epsilon0);

Na = N_fi*cos(epsilon);
end