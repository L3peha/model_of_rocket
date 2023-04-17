function [W1] = eulerRightPart(J,Tsum,h,hdot,W)
%eulerRightPart правая часть динамических уравнений Эйлера
% Интегрирование динамических уравнений Эйлера
W1 = J^(-1)*(-cross(W,(J*W+h))-hdot+Tsum);

end