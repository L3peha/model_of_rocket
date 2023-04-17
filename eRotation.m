function [R] = eRotation(JD, Na)
%eRotation рассчет матрицы вращения Земли

d = JD;
M = d - 0.5 - floor(d-0.5);
tau = d/36525;
S_mean = 1.7533685592 + 0.0172027918051*d + 6.2831853072*M + ...
    6.7707139*10.^(-6)*tau.^2 - 4.50876*10.^(-10)*tau.^3;
S_true = S_mean + Na;

R = [cos(S_true) sin(S_true) 0;
     -sin(S_true) cos(S_true) 0;
     0 0 1];

end