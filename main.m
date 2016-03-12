
clear all; close all; clc;

% Obtain Pitch using Correlation

%Exp_1_Sn1_94ms_48KHz

[x, fs] = wavread('038. Simple Plan_ex_ham_foreground.wav');
frame_length = 40;
frame_overlap = 20;
maxlag = 20;
show = 1;
[F0, T, R] = spPitchTrackCorr(x, fs, frame_length, frame_overlap, maxlag, show);




% Obtain Pitch using AutoCorrelation [VKM Sir]

clear all; close all; clc;
[x, fs] = wavread('038. Simple Plan_72ms_ex_ham_foreground.wav');
x = x(:, 1);
fsize = 40;
fshift = 20;
plotFlag = 2;

autocorr(x,fs,fsize,fshift,plotFlag)


% clear all; close all; clc;
% maxlag = 20;
% show = 0;
% [x, fs] = wavread('Exp_1.wav');
% [r] = spCorr(x, fs, maxlag, show)
% 
% 
% [f0] = spPitchCorr(r, fs)