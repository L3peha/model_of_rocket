function [] = modAstro()
%modAstro Модель движения астроориентиров (Солнце, Луна, Земля) 
global julianCent;      %<-
global modQJ2k2Body;    %<-Кватернион разворота связанного базиса относительно ИСК J2000
global vSunBody;        %-> Орт направления на солнце в связанном базисе

vSunJ2k = sunPos(julianCent);
vSunBody = (quatrotate(modQJ2k2Body, vSunJ2k'))';

end