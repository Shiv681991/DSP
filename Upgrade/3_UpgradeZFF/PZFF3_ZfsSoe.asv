
% Steps in Computation of Instantaneous Fundamental Frequency From Speech Signals
% 1) Compute the difference speech signal .
% 2) Compute the average pitch period using the histogram of
% the pitch periods estimated from the autocorrelation of 30
% ms speech segments. 
% 3) Compute the output of the cascade of two zero-frequency
% resonators.
% 4) Remove trend: Compute the filtered signal from using a window
% length corresponding to the average pitch period.
%plot(zSig);
% 5) Compute the instantaneous fundamental (pitch) frequency
% from the positive zero crossings of the filtered signal. The
% locations of the positive zero crossings are given by the
% indices for which diff(sgn(y[n])) = 2
%**************************************************************************
% YET TO BE RESOLVED...
% 6) Obtain the pitch contour ps[m] for every 10 ms from the
% instantaneous pitch frequency by linearly interpolating the
% values from adjacent GCIs. This step is used mainly for
% comparison with the ground truth values, which are available
% at 10 ms intervals.

%-->derive from pitchZeroCrossings(wav,fs)


% 7) Compute the Hilbert envelope of speech signal .
% 8) Compute the pitch contour from the filtered signal of the hilbert
% envelope.
% 9) Replace the value in with whenever ps[m]> 1.5 ph[m].
% Note: Normally, the trend removal operation in step 4) above
% needs to be applied only once, if the duration of the speech signal
% being processed is less than about 0.1 s. For longer (up to 30 s)
% durations, it may be necessary to apply this trend removal operation
% several (3 or more) times, due to rapid growth/decay of
% the output signal .




% % Here zerocros from voicebox is used.
% x = zSig;
% m = 'p';
% [t,s]=zerocros(x,m);

%F0
% 
% P_vec = [0; t];
% PP = diff(P_vec);
% F0 = fs./PP;
% plot(F0);



clear all; close all; clc;
[sig, fs] = wavread('2.wav');
sig = sig(:, 1);
[zSig, n1, wlen] = zFF(sig, fs);
[if0,it0,slope,it] = computeF0andSlope(sig, zSig, fs, 0);


 N = length(sig);
	% plot waveform
    ax(1) = subplot(4,1,1);
    t = (0:N-1)/fs;
    plot(t, sig, 'k');
    title('Music: 1__038. Simple Plan__ex__75ms');
    xlabel('Time (s)');
    ylabel('Amplitude');
    xlim([t(1) t(end)]);
    
    ax(2)=subplot(4,1,2); 
    plot((1:length(zSig))/fs,zSig, 'k');
    title('ZFF Signal');
    ylabel('Amplitude');
    grid;
    xlim([0 (n1-wlen*3)/fs]);
% 	

    % plot F0 track
    ax(3) = subplot(4,1,3);
    plot(it,if0, 'k.');
    title('pitch track');
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    xlim([t(1) t(end)]);
    
     % plot Phase 
    ax(4) = subplot(4,1,4);
    stem(it,slope./max(slope), 'k');
    title('slope plot');
    xlabel('Time (s)');
    ylabel('Intensity');
    xlim([t(1) t(end)]);
    linkaxes(ax,'x');

% %SOE
% wav = sig;
% [zfSig,vnv,vgci,vpc,st,gci]=epochStrengthExtract_v3(wav,fs)


