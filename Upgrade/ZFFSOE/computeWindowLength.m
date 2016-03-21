function [avgt0, nc, edges]= computeWindowLength(s,fs,preempflag, plotflag)
plotflag = 0;
if preempflag == 1
	s1 = diff(s);
	s1(length(s)) = s1(end);
	clear s;
	s = s1;
end
ls = length(s);

% Analysis parameters.
sz = 30; % in ms
sh = 3; % in ms.

N = floor(sz*fs/1000);
L = floor(sh*fs/1000);
minT0 = floor(3.0*fs/1000);

% For autocorrelation of speech.

bufs = buffer(s,N,N-L,'nodelay');
[r,c] = size(bufs);
posPeak = [];
for i=1:c
	ac1 = xcorr(bufs(:,i));
	ac = ac1(N:2*N-1)/max(ac1);
	ac(1:minT0) = 0;
        y1 = [diff(ac) > 0];
        y2 = [diff(ac) <= 0];
        [locPeaks] = find((y1(1:length(y1)-1) + y2(2:length(y2))) == 2);
        if isempty(locPeaks) == 0
                locPeaks = locPeaks(:) + ones(length(locPeaks),1);
                [acmaxval,pos] = max(ac(locPeaks));
                posPeak(i) = locPeaks(pos);
		acmax(i) = acmaxval;
        else
                posPeak(i) = minT0;
		acmax(i) = 0;
        end
	posPeak(i) = posPeak(i)*1000/fs;
end

t0ms = posPeak;

threshold = 0.4;
locv = find(acmax > threshold);
vad = [acmax > threshold];

T0 = t0ms(locv);

edges = [2:2:18];
[nc,bin] = histc(T0, edges);

%nc(1:2) = 0;
nc = nc/sum(nc);

[maxnc, binpos] = max(nc);
avgt0 = ceil(mean(T0));

if plotflag == 1
	figure;
        xaxis = [floor(N/2):L:floor(N/2) + (c-1)*L + 2]/fs; % In seconds.

        ax(1) = subplot(3,1,1);
        plot([1:length(s)]/fs, s, 'k');
        xlim([1/fs length(s)/fs]);
        ylim([-1 1]);

        ax(2) = subplot(3,1,2);
        plot(xaxis, acmax, 'k');
	hold on;
        plot(xaxis, vad, 'r');
	hold off;
        xlim([1/fs length(s)/fs]);
        ylim([0 1.2]);

        ax(3) = subplot(3,1,3);
        plot(xaxis, t0ms,'k.');
        xlim([1/fs length(s)/fs]);
        ylim([0 15]);
        ylabel('(ms)');

        linkaxes(ax, 'x');

        xlabel('Time (s)');


	figure;
	bar(edges, nc/sum(nc));
        xlabel('Pitch period (ms)');
end
