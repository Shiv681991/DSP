function [f0, t0]= autocorr_vb(x,fs,fsize,fshift,plotFlag)

% x: Signal
% fs: sampling frequency
% fsize,fshift in ms.
% If plotFlag == 0, no plots are generated.
s= x./max(x);
% Preemphasize the signal.
s = diff(x);

% Convert from milliseconds to samples
N = floor(fsize*fs/1000);
L = floor(fshift*fs/1000);
minT0 = floor(2.5*fs/1000);  
 
% Arrange speech into blocks.
bufs = buffer(s,N,N-L,'nodelay');
[r,c] = size(bufs);

if plotFlag > 0
	figure;
end 
% i = 1;
% Compute autocorrelation for each block.
for i=1:c
	% ac1 is two-sided autocorrelation.
	ac1 = xcorr(bufs(:,i));

	% ac is one-sided autocorrelation.
	ac = ac1(N:2*N-1);

    % Check if the signal segment has zero energy.
	if max(ac1) ~= 0 
		ac = ac/max(ac1);
	end

	% Plot signal and autocorrelation for each block.
	if plotFlag == 2
		bx(1)=subplot(2,1,1);
		plot([1:r]*1000/fs, bufs(:,i), 'k');grid;
	
		bx(2)=subplot(2,1,2);
		plot([1:r]*1000/fs, ac,'k');grid;

		linkaxes(bx, 'x');
		xlabel('Time (ms)');
	
		pause
    end 
% **************************************************************************
%  Detect peak in the frame using Voice box   
%  [k,v]=v_findpeaks(ac,'f',0)
% **************************************************************************    
% Signal and peaks identified for each block.
% 	if plotFlag == 3
%         bx(1)=subplot(2,1,1);
%         plot([1:r]*1000/fs, bufs(:,i), 'k');grid;
% 		bx(2)=subplot(2,1,2);
% 		plot([1:r]*1000/fs, ac,'k');grid;
% 	hold on; plot(k*1000/fs, v,'ro');grid;
%          xlabel('Time (ms)');
% 		linkaxes(bx, 'x');		
%     end  
% **************************************************************************   

%**************************************************************************

	% Detect  peaks in autocorrelation sequence.
	ac(1:minT0) = 0;


        y1 = [diff(ac) > 0]; 	% Positive y1 indicates increasing trend.
        y2 = [diff(ac) <= 0];	% Positive y2 indicates decreasing trend.

	% Identify 1-0 transitions in y1, or identify 0-1 transition in y2.
        [locPeaks] = find((y1(1:length(y1)-1) + y2(2:length(y2))) == 2);
        
       
        
        if isempty(locPeaks) == 0
		locPeaks = locPeaks(:) + ones(length(locPeaks),1);
        
        
            [acmaxval(i),pos] = max(ac(locPeaks));
		maxpos(i) = locPeaks(pos);
	else
		acmaxval(i) = 0.001;
		maxpos(i) = 1;
	end

	clear y1 y2 locPeaks;
end
% %************************************************************************** 
% %Check the peaks for VKM Sir's peak detection
%  %Signal and peaks identified for each block.
% %**************************************************************************
%     	
% if plotFlag == 4
%             bx(1)=subplot(2,1,1);
%             plot([1:r]*1000/fs, bufs(:,i), 'k');grid;
%     		bx(2)=subplot(2,1,2);
%     		plot([1:r]*1000/fs, ac,'k');grid;
%             LPT = maxpos*1000/fs;
%     	hold on; plot(LPT, ac(maxpos),'ro');grid;
%              xlabel('Time (ms)');
%     		linkaxes(bx, 'x');		
%         end  
% %**************************************************************************
% Median filtering
t0 =  medfilt1(maxpos,5)*1000/fs;
f0 = 1000./t0;
if plotFlag == 1

	xaxis = [floor(N/2):L:floor(N/2) + (c-1)*L + 2]/fs; % In seconds.

	ax(1) = subplot(4,1,1);
	plot([1:length(s)]/fs, s, 'k');
	xlim([1/fs length(s)/fs]);
	ylim([-1 1]);

	ax(2) = subplot(4,1,2);
	plot(xaxis, acmaxval, 'k');
	xlim([1/fs length(s)/fs]);
	ylim([0 1]);

	ax(3) = subplot(4,1,3);
	plot(xaxis, t0,'k.');
	xlim([1/fs length(s)/fs]);
	ylim([0 15]);
	ylabel('(ms)');
    
    ax(4) = subplot(4,1,4);
	plot(xaxis, f0,'k.');
	xlim([1/fs length(s)/fs]);
% 	ylim([0 15]);
	ylabel('(Hz)');
	
	linkaxes(ax, 'x');
	
	xlabel('Time (s)');

end

