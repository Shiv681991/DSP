function [zfSig, N, winLength]=zFF(wav,fs)
% winLength = xcorrWinLen(wav,fs);
 [winLength, nc, edges]= computeWindowLength(wav,fs,1, 0)
% Difference the speech signal...
	dwav=diff(wav);
	dwav=dwav/max(abs(dwav));
	N=length(dwav);

% Pass the differenced speech signal twice through zero-frequency resonator..	
	zfSig=cumsum(cumsum(cumsum(cumsum(dwav))));

plotFlag=0;

if(plotFlag==1)
	figure; 
	ax(1)=subplot(5,1,1); plot((1:length(wav))/fs, wav/max(abs(wav))); grid;
	title('Speech signal');
end
% Remove the DC offset introduced by zero-frquency filtering..	
	winLength=round(winLength*fs/1000);

if(plotFlag==1)
	ax(2)=subplot(5,1,2); plot((1:length(zfSig))/fs,zfSig);grid;
	title('Output of cascade of zero frequency resonators, y2[n]');
end
%**************************************************************************
%First Trend Reoval
	zfSig=remTrend(zfSig,winLength);
	temp=zfSig; %temp(N-winLength:N)=0;
%**************************************************************************
if(plotFlag==1)
	ax(3)=subplot(5,1,3); plot((1:length(temp))/fs,temp);grid;
	title('Output after first trend removal');
end

%**************************************************************************
%Second Trend Reoval
	zfSig=remTrend(zfSig,winLength);
	temp=zfSig; %temp(N-winLength*2:N)=0;
%**************************************************************************
if(plotFlag==1)
	ax(4)=subplot(5,1,4); plot((1:length(temp))/fs,temp);grid;
	title('Output after second trend removal');
end
%**************************************************************************
%UNACCOUNTED TREND REMOVAL
	zfSig=remTrend(zfSig,winLength);
	temp=zfSig; %temp(N-winLength*2:N)=0;
%	ax(4)=subplot(5,1,4); plot((1:length(temp))/fs,temp);grid;
%	title('Output after second trend removal');
%**************************************************************************
%**************************************************************************
%Third Trend Removal
	zfSig=remTrend(zfSig,winLength);
	zfSig(N-winLength*3:N)=0;
%**************************************************************************
if(plotFlag==1)
%	ax(5)=subplot(5,1,5); plot((1:length(zfSig))/fs,zfSig/max(abs(zfSig)));grid;
	ax(5)=subplot(5,1,5); plot((1:length(zfSig))/fs,zfSig);grid;
	title('Output after third trend removal');
	xlabel('Time (s)');
	linkaxes(ax,'x');
	xlim([0 (N-winLength*3)/fs]);
end

plotFlag=1;

if(plotFlag==1)
	figure;
	ax(1)=subplot(2,1,1); plot((1:length(wav))/fs, wav/max(abs(wav))); grid;
	title('Speech signal');
	ax(2)=subplot(212); plot((1:length(zfSig))/fs,zfSig);grid;xlim([0 (N-winLength*3)/fs]);
	linkaxes(ax,'x');
end


function [out]=remTrend(sig,winSize)

	window=ones(winSize,1);
	rm=conv(sig,window);
	rm=rm(winSize/2:length(rm)-winSize/2);

	norm=conv(ones(length(sig),1),window);
	norm=norm(winSize/2:length(norm)-winSize/2);

	rm=rm./norm;
	out=sig-rm;
    
    function [idx]=xcorrWinLen(wav,fs)

%	zfSig=zeroFreqFilter(wav,fs,2);
%	zfSig=zfSig/max(abs(zfSig));
%	wav=zfSig;

	frameSize=30*fs/1000;
	frameShift=20*fs/1000;

	en=conv(wav.^2,ones(frameSize,1));
	en=en(frameSize/2:end-frameSize/2);
	en=en/frameSize;
	en=sqrt(en);
	en=en>max(en)/5;

	b=buffer(wav,frameSize,frameShift,'nodelay');
	vad=sum(buffer(en,frameSize,frameShift,'nodelay'));

	FUN=@(x) xcorr((x-mean(x)).*hamming(length(x)),'coeff')./xcorr(hamming(length(x)),'coeff');
	out=blkproc(b,[frameSize,1],FUN);

	out=out(frameSize:end,:);
	
	minPitch=3;  %2 ms == 500 Hz.
       	maxPitch=16; %16 ms == 66.66 Hz.	

	[maxv, maxi]=max(out(minPitch*fs/1000:maxPitch*fs/1000,:));

	%h=hist(maxi(vad>frameSize/2)+minPitch,(3:15)*8-4);
	x=(minPitch:0.5:maxPitch)*fs/1000+2;
	pLoc=maxi(vad>frameSize*0.8)+minPitch*fs/1000;
	y=hist(pLoc,x);
	y=y/length(pLoc);
	
	%bar(x,y,1,'EdgeColor',[1 1 1],'FaceColor',[0 0 0]);
	%set(gca,'xTick',(1:maxPitch)*fs/1000+0.5*fs/1000, 'xTickLabel',(1:maxPitch));
	%set(gca,'yTick',[0 0.1 0.2 0.3 0.4],'yTickLabel',[0 0.1 0.2 0.3 0.4]);
	%xlabel('Time (s)');
	%ylabel('Normalized frequency');
        %allText   = findall(h, 'type', 'text');
        %allAxes   = findall(h, 'type', 'axes');
        %allFont   = [allText; allAxes];
	%xlim([1 maxPitch+1]*fs/1000)
        %set(allFont,'FontSize',18);

	%advexpfig(h,'hist.eps','-deps2c','w',20,'h',20);

	%close(h);

	[val, idx]=max(y);
	idx=round(idx/2)+minPitch+2;

