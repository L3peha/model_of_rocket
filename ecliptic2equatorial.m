function [alpha,delta] = ecliptic2equatorial(phi,lambda,epsilon)
%ecliptic2equatorial Summary of this function goes here
%   Detailed explanation goes here

M = [1     0              0
    0  cos(epsilon) sin(epsilon) 
    0 -sin(epsilon) cos(epsilon)];

Vecl = [cos(phi)*cos(lambda)
        cos(phi)*sin(lambda)
        sin(phi)];

vEq = M*Vecl;

delta = asin(vEq(3));
if abs(delta)<pi/2-1E-9
    alpha = acos(vEq(1)/cos(delta));
    if(vEq(2)/cos(delta)<0)
        alpha = 2*pi-alpha;
    end
else
    alpha = 0;
end

end