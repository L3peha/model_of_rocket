function [] = bortAlg()
%bortAlg  Бортовые алгоритмы управления
%   Обработка измерений датчиков и формирование
%   управляющих сигналов на исполнительные органы
global bortCtrlAct;
global bortQOsk2Body;
global bortWIzm;
global bortOrientMode;          % Режим ориентации в котором работают бортовые программы
bortOrientMode = 0;


bortWbound = 0.05;              % Граница  управления по угловой скорости, град/с
eps = [0.002 0.002 0.002];

if bortOrientMode == 0
    w = rad2deg(bortWIzm);
    for ch=1:1:3
        if abs(w(ch))>bortWbound
            dw = w(ch) - bortWbound*sign(w(ch));
        else
            dw=0;
        end
        if dw>0
            bortCtrlAct((ch-1)*2+2) = abs(dw/eps(ch))*100;
            bortCtrlAct((ch-1)*2+1) = 0;
        elseif dw<0
            bortCtrlAct((ch-1)*2+1) = abs(dw/eps(ch))*100;
            bortCtrlAct((ch-1)*2+2) = 0;
        else
            bortCtrlAct((ch-1)*2+1) = 0;
            bortCtrlAct((ch-1)*2+2) = 0;
        end
    end
    for thr=1:1:6
        if  bortCtrlAct(thr) < 3
            bortCtrlAct(thr) = 0;
        elseif bortCtrlAct(thr) > 20
            bortCtrlAct(thr) = 20;
        end
        bortCtrlAct(thr) = floor(bortCtrlAct(thr));
    end
end

end