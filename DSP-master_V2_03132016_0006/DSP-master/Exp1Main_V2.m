%Exp 1

% Resample every audio to 10KHz : Stored at : C:\Shivam\Research @ IIITS\Music Source Separation\Phase III\Music source separation_Phase 3_LPC, ZFF, Vocal Enhancement\Foreground_5M+5F_Blackman
clear all; close all; clc;
[x, fs] = wavread('038. Simple Plan_ex_ham_foreground_90ms_48KHz.wav');

x1 = resample(x, 5, 24);
fs1 = 10000;
% audiowrite('038. Simple Plan_ex_ham_foreground_90ms_10KHzRe.wav', x1, 10000);



%Take in any of the resampled signal
clear all; close all; clc;
[x, fs] = wavread('038. Simple Plan_ex_black_foreground.wav');
x1 = resample(x, 100, 441);
fs1 = 10000;
% Capture the 80 ms excerpt
t = 80; % in ms
n = t.*fs1./1000;
x1 = x1(1:n);
maxlag = 20;
show = 0;
% Plots
% Take the auto correlation and Pitch contour, separately, along with the
% original signal and compare the following frame combinations with the
% original sampling rate.
% 1. Size : 10 ms; Shift :  3 ms;
% 2. Size :  5 ms; Shift :  1 ms;
% 3. Size : 30 ms; Shift : 10 ms;
% 4. Size : 50 ms; Shift : 20 ms;


% %Autocorrelations Plots
% 
% %Autocorrelation computation
% %Case 1:
% frame_length = 50;
% frame_overlap = 30; % ms shift
% [F0, T, R] = spPitchTrackCorr(x1, fs1, frame_length, frame_overlap);


%Pitch contour comparison at 10 KHz
frame_length = 10;
frame_overlap = 7;

[F01, T, R] = spPitchTrackCorr(x1, fs, frame_length, frame_overlap, maxlag, show);
[F02, T, R] = spPitchTrackCorr(x1, fs, frame_length, frame_overlap, maxlag, show);
[F03, T, R] = spPitchTrackCorr(x1, fs, frame_length, frame_overlap, maxlag, show);
[F04, T, R] = spPitchTrackCorr(x1, fs, frame_length, frame_overlap, maxlag, show);

N = length(x1);

%x = x(:, 1);
figure;
t = (0:N-1)/fs;
    subplot(5,1,1);    
    plot(t, x1);
    title('Original Signal, resampled to 10KHz');
    legend('Waveform');
    xlabel('Time (s)');
    ylabel('Amplitude');
    xlim([t(1) t(end)]);
    
    % Case 1
    subplot(5,1,2);
    plot(T,F01, '.');
    legend('Pitch (Size: 10 ms; Shift: 3 ms');
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    xlim([t(1) t(end)]);
    
    % Case 2
    subplot(5,1,3);
    plot(T,F02, '.');
    legend('Pitch (Size: 5 ms; Shift: 1 ms)');
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    xlim([t(1) t(end)]);
    
    % Case 3
    subplot(5,1,4);
    plot(T,F03, '.');
    legend('Pitch (Size: 30 ms; Shift: 10 ms)');
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    xlim([t(1) t(end)]);
    
    % Case 4
    subplot(5,1,5);
    plot(T,F04, '.');
    legend('Pitch (Size: 50 ms; Shift: 20 ms)');
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    xlim([t(1) t(end)]);

