function [] = timeProgram()
%timeProgram Summary of this function goes here
%   Detailed explanation goes here

global bortStep;
global bortTime;
global julianDays; %кол-во юлиан суток с эпохи J2000
global julianCent;

bortTime = bortTime + bortStep;

referenceTime = datenum(2023,02,13,11,19,30);
dateNumber = referenceTime + bortTime/86400;
dateVector = datevec(dateNumber);

year = dateVector(1);
month = dateVector(2);
day = dateVector(3);
hour = dateVector(4);
minute = dateVector(5);
second = dateVector(6);

JD = 367*year - floor(7*(year+floor((month+9)/12))/4)+floor(275*month/9)+day+1721013.5+((second/60+minute)/60+hour)/24;
julianDays = JD - 2451545.0;
julianCent = julianDays/36525;





end