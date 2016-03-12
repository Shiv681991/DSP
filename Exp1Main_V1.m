%Exp 1

% Resample every audio to 10KHz
clear all; close all; clc;
[x, fs] = wavread('038. Simple Plan_ex_ham_foreground_90ms_48KHz.wav');

x1 = resample(x, 5, 24);
fs1 = 10000;
% audiowrite('038. Simple Plan_ex_ham_foreground_90ms_10KHzRe.wav', x1, 10000);



% Plots
t = (1:1./fs1:length(x1)./fs1);
x = x(:, 1);
% Plot 1: Comparing original and resampled signal
figure;
subplot(2, 1, 1);
p1 = plot(t, x);