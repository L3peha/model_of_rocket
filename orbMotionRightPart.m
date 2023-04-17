function [dX] = orbMotionRightPart(X)
%orbMotionRightPart Правая часть уравнений орбитального движения КА
dX = [X(4:6)];
r = [X(1:3)];
dX(4:6) = modGravAccel(r);
end