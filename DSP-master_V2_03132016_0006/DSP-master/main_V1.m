%**************************************************************************
% Main file for Pitch extraction workout using Autocorrelation
%**************************************************************************
%1. Obtain Pitch using Correlation with Plots
%2. Obtain Pitch using AutoCorrelation [VKM Sir] with Plots
%3. Filtering (LPF and BPF) with Plots
%**************************************************************************
%Exp_1_Sn1_94ms_48KHz
%038. Simple Plan_ex

clear all; close all; clc;

% Obtain Pitch using AutoCorrelation SONOTS
[x, fs] = wavread('038. Simple Plan_ex_ham_foreground.wav');
frame_length = 40;
frame_overlap = 20;
maxlag = 20;
show = 0;
[F0, T, R] = spPitchTrackCorr(x, fs, frame_length, frame_overlap, maxlag, show);




% Obtain Pitch using AutoCorrelation [VKM Sir]
clear all; close all; clc;
[x, fs] = wavread('038. Simple Plan_ex_ham_foreground.wav');
x = x(:, 1);
fsize = 40;
fshift = 20;
plotFlag = 1;

autocorr(x,fs,fsize,fshift,plotFlag)


% clear all; close all; clc;
% maxlag = 20;
% show = 0;
% [x, fs] = wavread('Exp_1.wav');
% [r] = spCorr(x, fs, maxlag, show)
% 
% 
% [f0] = spPitchCorr(r, fs)

% Filtering (LPF and BPF)

clear all; close all; clc;

[x, fs] = wavread('038. Simple Plan_ex_black_foreground.wav');
x = x(:, 1);
x = x./max(x);
%LPF
% y = MATlpf(x);

%BPF
y = bpfPdata(x);
y = max(y);
% plotting the filtered signal against the original signal

% t = [2:1./fs:length(x)./fs];
t = [1:length(x)]./fs;
figure;
subplot(2, 1, 1);
plot(t, x);
title('Original Wave');

subplot(2, 1, 2)
plot(t, y);
title('BPF wave');
hold;

%Commiting the filtered signal

audiowrite('038. Simple Plan_72ms_ex_black_foreground_BPF_3Full.wav', y, fs);

