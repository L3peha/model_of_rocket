function [] = modActuators()
%modActuators Модель исполнительных органов КА
%   Формирует силы и моменты от исполнительных органов КА
global modCtrlAct;
global modCtrlActPrev;
global modCtrlTorgue;  %-> управляющий момент от исполнительных органов
global modNSub;         %<- Количество подтактов, на которое разбивается интегрирование углового движения
global modCtrlForce;
% Координаты установки ДО, м
doCrd = [ 0.0 0.0 -0.5
         0.0 0.0 0.0
        -0.5 -0.5 0.5
         0.5 -0.5 0.5
         0.5 0.0 0.0
        -0.5 0.0 0.0];

cos45 = cos(deg2rad(45));
% Направления действия тяг
doDir = [0.0 cos45 cos45
    0.0 cos45 -cos45
    cos45 0.0  cos45
    -cos45 0.0 cos45
    -cos45 cos45 0.0
    cos45 cos45 0.0];

rcm = [0 -0.5 0.0]';
doThrust = 2;               % Номинальная величина тяги ДО, Н

for subfr = 1:1:modNSub
    modCtrlForce(:,subfr) = [0 0 0]';
    modCtrlTorgue(:,subfr) = [0 0 0]';

    if subfr<17
        t = 0.04+subfr*0.01;
    else
        t = (subfr-17)*0.01;
    end

    for thr=1:1:6
        if subfr<17
            tau = modCtrlActPrev(thr);
        else
            tau = modCtrlAct(thr);
        end

        if tau>20
            tau = 20;
        end

        if t<=tau/100 && tau>0
            thrust = doThrust;
        else
            thrust = 0;
        end
        
        doForce = thrust*doDir(thr,:)';
        doArmOfForce = doCrd(thr,:)' - rcm;
        doTorque = cross(doArmOfForce,doForce);

        modCtrlForce(:,subfr) = modCtrlForce(:,subfr) + doForce;
        modCtrlTorgue(:,subfr) = modCtrlTorgue(:,subfr) + doTorque;
    end
end

modCtrlActPrev = modCtrlAct;
end