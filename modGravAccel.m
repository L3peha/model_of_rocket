function [g] = modGravAccel(R)
%modGravAccel Рассчет величины гравитационного ускорения
%   Расчет ускорения, создаваемого гравитационными силами с использованием
%   первых двух гармоник разложения нормального гравитационного потенциала
x = R(1);
y = R(2);
z = R(3);

%% константы
eps = 2.634*10^10;  %   км^5/c^2
hi = 6.773e15;      %   км^7/c^2
mu = 398600.4418;   %   км^3/c^2
rho = sqrt(x^2+y^2+z^2);

%% вычисление ускорения
g(1) = -x/rho^3*(mu + eps/rho^2 * (5*z^2/rho^2 - 1) + hi/(7*rho^4)*(63*z^4/rho^4 - 42*z^2/rho^2 + 3));
g(2) = -y/rho^3*(mu + eps/rho^2 * (5*z^2/rho^2 - 1) + hi/(7*rho^4)*(63*z^4/rho^4 - 42*z^2/rho^2 + 3));
g(3) = -z/rho^3*(mu + eps/rho^2 * (5*z^2/rho^2 - 3) + hi/(7*rho^4)*(63*z^4/rho^4 - 70*z^2/rho^2 + 15));

end