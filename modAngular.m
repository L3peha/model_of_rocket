function [] = modAngular()
%modAngular Модель углового движения КА
%   Формирует параметры ориентации КА относительно различных систем
%   координат и угловую скорость
global modQJ2k2Body;    %-> Кватернион разворота связанного базиса относительно ИСК J2000
global modQJ2k2Osk;     %<- Кватернион перехода от ИСК J2000 к ОСК
global modQOsk2Body;    %-> кватернион перехода от ОСК к связанному базису
global modWorb;         %<- модуль угловой скорости орбитального движения
global modMTI;          %<- матрица тензора инерции КА
global bortStep;        %<- шаг интегрирования, с
global modNSub;         %<- Количество подтактов, на которое разбивается интегрирование углового движения
global modCtrlTorgue;  %<- управляющий момент от исполнительных органов
global modWSolid;       %<- Угловая скорость твердого тела
global modW_sub;        %<- Угловая скорость на подтактах
%% Рассчет гравитационного момента
ortY = [0 1 0];
Worb = norm(modWorb);
%% Вычисление аэродинамического момента
modTaero = [0 0 0]';
% Шаг интегрирования
tau = bortStep/modNSub;
%% Так как не используем инерциальные исполнительные органы то зануляем моменты от них
h = [0 0 0]';
hdot = [0 0 0]';
%% Интегрирование уравнений эйлера
for sub = 1:1:modNSub
    % Рассчет гравитационного момента
    modQOsk2Body = quatmultiply(modQJ2k2Body, quatconj(modQJ2k2Osk));
    j = quatrotate(modQOsk2Body, ortY)';
    Tgrav = 3*Worb^2*cross(j,modMTI*j);
    % Расчет суммарного возмущаеющего и управляющего момента
    Tsum = Tgrav + modTaero + modCtrlTorgue(:,sub);
    %% Интегрирование уравнений эйлера методом Рунге-Кутта 4-го порядка
    K1 = eulerRightPart(modMTI,Tsum,h,hdot,modWSolid);
    K2 = eulerRightPart(modMTI,Tsum,h,hdot,modWSolid+tau/2*K1);
    K3 = eulerRightPart(modMTI,Tsum,h,hdot,modWSolid+tau/2*K2);
    K4 = eulerRightPart(modMTI,Tsum,h,hdot,modWSolid+tau*K3);
    modWSolid = modWSolid + tau/6.0 *(K1+2*K2+2*K3+K4);
    modW_sub(:,sub) = modWSolid;

    %% Интегрирование кинематических уравнений Эйлера
    rotW = tau*0.5*modWSolid;
    ksi = 0.5*(1-norm(modQJ2k2Body)^2)-norm(modQJ2k2Body)^2*norm(rotW)^2;
    modQJ2k2Body = modQJ2k2Body+ (1 + ksi)*quatmultiply(modQJ2k2Body,[0 rotW']) + ksi*modQJ2k2Body;
end
modQOsk2Body = quatmultiply(modQJ2k2Body, quatconj(modQJ2k2Osk));
end