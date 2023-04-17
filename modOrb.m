function [] = modOrb()
%modOrb Summary of this function goes here
%   Detailed explanation goes here
global modRJ2k; 
global modVJ2k;
global modRGsk; 
global modVGsk;
global modQJ2k2Osk;
global modQJ2k2Grn;
global modorbWOrb;
global julianDays; %кол-во юлиан суток с эпохи J2000
global julianCent;
global modWorb;
global bortStep;
global modFi_gd;
global modLam_gd;

%% Положение и скорость КА в гринвической СК
wEarth = [0 0 7.292115e-5]';
% Перевод в текущую инерциальную СК
R = modRGsk;
V = modVGsk + cross(wEarth,R);
% Интегрирование уравнений движения
X = [R' V']';
K1 = orbMotionRightPart(X);
K2 = orbMotionRightPart(X+K1*bortStep/2.0);
K3 = orbMotionRightPart(X+K2*bortStep/2.0);
K4 = orbMotionRightPart(X+K3*bortStep);
X1 = X + bortStep/6.0 * (K1 + 2*K2 + 2*K3 + K4);

% учет вращения гринвической СК
X(1) = X1(1)*cos(bortStep*wEarth(3))+X1(2)*sin(bortStep*wEarth(3));
X(2) = -X1(1)*sin(bortStep*wEarth(3))+X1(2)*cos(bortStep*wEarth(3));
X(3) = X1(3);
X(4) = X1(4)*cos(bortStep*wEarth(3))+X1(5)*sin(bortStep*wEarth(3));
X(5) = -X1(4)*sin(bortStep*wEarth(3))+X1(5)*cos(bortStep*wEarth(3));
X(6) = X1(6);


% Перевод в гринвическую СК из текущей инерциальной СК
modRGsk = X(1:3);
modVGsk = X(4:6) - cross(wEarth,modRGsk);

modGravAccel(modRJ2k);

%% Рассчет матрицы перехода от ГСК к ИСК J2000
P = ePrecession(julianCent);
[N, Na] = eNutation(julianCent);
R = eRotation(julianDays, Na);
wEarth = [0 0 7.292115e-5]';

M = (R*N*P);
mGrn2J2k = M';
modRJ2k = mGrn2J2k*modRGsk;
modVJ2k = mGrn2J2k*modVGsk + cross(wEarth,modRGsk);
modQJ2k2Grn = dcm2quat(M);


modWorb = cross(modRJ2k,modVJ2k)./(norm(modRJ2k)^2);
%% рассчет кватерниона перехода от ОСК к ИСК
OyOCK = modRJ2k/norm(modRJ2k);
OzOCK = -cross(modRJ2k,modVJ2k)/norm(cross(modRJ2k,modVJ2k));
OxOCK = cross(OyOCK,OzOCK);

matrixx = [OxOCK OyOCK OzOCK]';

OCK = dcm2quat(matrixx);

modQJ2k2Osk = OCK;

modorbWOrb = quatrotate(OCK,modWorb');

%% Рассчет геоцентрических координат КА
r = norm(modRGsk);
fi_gc = asin(modRGsk(3)/r);
if abs(fi_gc)<pi/2 - 0.0000001
    lam_gc = rad2deg(acos(modRGsk(1)/r/cos(fi_gc)));
    if modRGsk(2)<0
        lam_gc=360-lam_gc;
    end
else
    lam_gc=0;
end
fi_gc = rad2deg(fi_gc);

[modFi_gd, modLam_gd, h] = dec2geodetic(modRGsk);
end