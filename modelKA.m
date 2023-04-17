clc; clear; close all;
format long;
global bortTime;    % Шаг , с
global modRGsk;
global modVGsk;
global modFi_gd;
global modLam_gd;
global modQOsk2Body;    % кватернион перехода от ОСК к связанному базису
global modQJ2k2Body;    % Кватернион разворота связанного базиса относительно ИСК J2000
global modWSolid;       % Угловая скорость твердого тела

% Задание начального состояния
initBort();
initModel();
initBort();

% Непосредственно моделирование полёта КА
for t=1:1:(60*5)

    timeProgram();        % Формирование времени
    
    bortAlg();              % Бортовые алгоритмы  
    exchangeBortModel();    % Передача данных из борта в модель
    
    % Вызов модельных программ
    modAstro();             % Модель движения астроориентиров (Солнце, Луна, Земля)
    modActuators();         % Модель исполнительных органов КА
    modOrb();               % Модель орбитального движения КА
    modAngular();           % Модель углового движения КА
    modAngVelSensor();      % Модель датчика угловой скорости
    modStarTracker();       % Модель звёздного датчика
    

    exchangeModelBort();    % Передача данных из модели в борт

    % Сохранение данных для отображения графиков
    time(t) = bortTime;
    rGsk(:,t) = modRGsk;
    vGsk(:,t) = modVGsk;
    Fi_gd(t) = modFi_gd;
    Lam_gd(t) = modLam_gd;
    w(:,t) = modWSolid;     %Угловая скорость КА как твердого тела
    [a b c] = quat2angle(modQOsk2Body);
    angOrb2Body(:,t) = rad2deg([a b c]');
    [a b c] = quat2angle(modQJ2k2Body);
    angJ2k2Body(:,t) = rad2deg([a b c]');
end

%% Отображение графиков различных параметров
figure(1);
plot(time,rGsk);
figure(2);
plot(time,vGsk);
figure(3);
plot(Lam_gd, Fi_gd);
figure(4);
plot(time,w);
figure(5);
plot(time,angOrb2Body);


