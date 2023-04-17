function [] = modAngVelSensor()
%modAngVelSensor Моделирования показаний датчика угловой скорости
%
global modWIzm;     % Вектор измерений угловой скорости
global modW_sub;

modWIzm = modW_sub(:,10);

end