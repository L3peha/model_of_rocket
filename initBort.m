function [] = initBort()
%initBort Summary of this function goes here
%   Detailed explanation goes here
global bortStep;
global bortTime;

bortStep = 0.2;
bortTime = 0;

global bortWIzm;
bortWIzm = [0 0 0]';

global bortQOsk2Body;
bortQOsk2Body = [1 0 0 0];
end