function [fi,lam, h] = dec2geodetic(r)
%dec2geodetic преобразование прямоугольныхдекартовых координат
%   в геодезические координаты
%% параметры земли
RE = 6378.1363;
fE = 1/298.25784;
eE = 2*fE-fE*fE;
%% Вычисление геодезических широты и долготы
D = sqrt(r(1)*r(1)+r(2)*r(2));
if D<0.0001
    fi = pi/2*r(3)/abs(r(3));
    lam = 0;
    h = r(3)*sin(fi) - RE*sqrt(1-eE*eE*sin(fi));
else
    % вычисляем долготу
    lam = acos(r(1)/D);
    if r(2)<0
        lam = 2*pi - lam;
    end
    if abs(r(3))<0.00001
        % на экваторе
        fi = 0;
        h = D - RE;
    else
        % находим вспомогательные величины
        R = norm(r);
        c = asin(r(3)/R);
        p = eE*eE*RE/(2*R);

        % итерации
        s1 = 0;
        d = 1000;
        while d>deg2rad(0.0001/3600)
           b = c + s1;
           s2 = asin(p*sin(2*b)/sqrt(1-eE*eE*sin(b)*sin(b)));
           d = abs(s1-s2);
           s1=s2;
        end
        fi=b;
        h = D*cos(fi)+r(3)*sin(fi) - RE*sqrt(1-eE*eE*sin(fi)*sin(fi));
    end
end
fi= rad2deg(fi);
lam = rad2deg(lam);
end