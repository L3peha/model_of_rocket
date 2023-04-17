function [] = exchangeBortModel()
%exchangeBortModel Передача информации из бортовых алгоритмов в модель
%
global modCtrlAct;
global bortCtrlAct;

modCtrlAct = bortCtrlAct;

end