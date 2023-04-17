function [] = initModel()
%initModel инициализация  начального состояния 
%   Detailed explanation goes here
global modRJ2k;
global modVJ2k;
global modRGsk;
global modVGsk;
global OCK;
global modQJ2k2Body;    %->Кватернион разворота связанного базиса относительно ИСК J2000
global julianDays;
global julianCent;
%% Задание начального положения КА в пространстве через элементы орбиты
earthMu = 398600.4418;          % Гравитационная постоянная Земли, км3/с2
orbInclination = 98;            % Наклонение орбиты, град
orbRaan = 45;                   % Долгота возходящего узла орбиты, град
orbEccentricity = 0.0005;       % эскцентриситет орбиты
orbMajorSemiaxis = 6400 + 650;  % большая полуось орбиты, км
orbArgOfPerigey = 60;           % Аргумент перигея, град
orbTrueAnomaly = -60;           % Истинная аномалия, град
% перевод углов в радианы
i = deg2rad(orbInclination);
Omega = deg2rad(orbRaan);
e = orbEccentricity;
a = orbMajorSemiaxis;
omega = deg2rad(orbArgOfPerigey);
theta = deg2rad(orbTrueAnomaly);

% Находим параметры орбиты
u = theta + omega;              % Аргумент широты, рад
p = a*(1-e^2);                  % Фокальный параметр конического сечения, км

% Перевод параметров орбиты в вектор состояния
re0(1) = cos(u)*cos(Omega) - cos(i)*sin(u)*sin(Omega);
re0(2) = cos(u)*sin(Omega) + cos(i)*sin(u)*cos(Omega);
re0(3) = sin(i)*sin(u);
re = re0';

n0(1) = -sin(u)*cos(Omega) - cos(i)*cos(u)*sin(Omega);
n0(2) = -sin(u)*sin(Omega) + cos(i)*cos(u)*cos(Omega);
n0(3) = sin(i)*cos(u);
n = n0';

rho = p/(1+e*cos(theta));

modRJ2k = rho*re;
modVJ2k = sqrt(earthMu/p)*(e*sin(theta)*re + (1+e*cos(theta))*n);

timeProgram();
% Рассчет матрицы перехода от ГСК к ИСК J2000
P = ePrecession(julianCent);
[N, Na] = eNutation(julianCent);
R = eRotation(julianDays, Na);
wEarth = [0 0 7.292115e-5]';

M = (R*N*P);
mJ2k2Grn = M;
modRGsk = mJ2k2Grn*modRJ2k;
modVGsk = mJ2k2Grn*modVJ2k - cross(wEarth,modRGsk);
%%
modQJ2k2Body = [1 0 0 0];
%modRJ2k = [1582.80676654741 -4471.9836829038 4841.91975089044]';
%modVJ2k = [5.58559188411198 4.64494295683307 2.45696789696147]';

modWorb = cross(modRJ2k,modVJ2k)./(norm(modRJ2k)^2);

OyOCK = modRJ2k/norm(modRJ2k);
OzOCK = -cross(modRJ2k,modVJ2k)/norm(cross(modRJ2k,modVJ2k));
OxOCK = cross(OyOCK,OzOCK);

matrixx = [OxOCK OyOCK OzOCK]';

OCK = dcm2quat(matrixx);

modorbWOrb = quatrotate(OCK,modWorb');

%% Задание начального углового положения КА
global modQJ2k2Body;
modQJ2k2Body = [1 0 0 0];

%% Задание массово-инерционных характеристик КА
global modMTI;
modMTI = [800 10 -12
           10 600 15
           -12 15 780];
global modNSub;         %-> Количество подтактов, на которое разбивается интегрирование углового движения
modNSub = 20;
%% Задание начальных угловых скоростей КА
global modWSolid;       %<- Угловая скорость твердого тела
modWSolid = deg2rad([0.5 -0.3 0.2]');

global modCtrlActPrev;
modCtrlActPrev = [0 0 0 0 0 0 ];

end