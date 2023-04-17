function [] = exchangeModelBort()
%exchangeModelBort Передача информации из модели в борт

global modWIzm;
global bortWIzm;
global modQOsk2Body;
global bortQOsk2Body;

bortWIzm = modWIzm;
bortQOsk2Body = modQOsk2Body;
end