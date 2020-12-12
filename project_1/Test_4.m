[x,fs]=audioread('C_01_01.wav');
[Pxx,w]=periodogram(x,[],512,fs);
b=fir2(3000,w/(fs/2),sqrt(Pxx/max(Pxx)));
noise=1-2*rand(1,length(x));
SSN=filter(b,1,noise)';
SSN=SSN/norm(SSN)*norm(x)*10^(0.25);%adjust intensity of SSN;
sig=x+SSN;
sig=sig/norm(sig)*norm(x);
%Set LPF and operate

%N=6,LPF=20Hz
sync20=[zeros(1,length(sig))]';
[LPF_b,LPF_a]=butter(4,20/(fs/2));
for i=1:6
    [l,h]=getFreq(6,i);
    [BP4_b,BP4_a]=butter(4,[l,h]/(fs/2));
    y4=abs(filter(BP4_b,BP4_a,sig));
    enve4=filter(LPF_b,LPF_a,y4);
    n=1:length(y4);dt=n/fs;f1=(l+h)/2;
    sin1=sin(2*pi*f1*dt)';
    enve4=enve4/norm(enve4)*norm(sig);
    sync20=sync20+enve4.*sin1;
end
sync20=sync20/norm(sync20)*norm(sig);
%plot(sync4);
audiowrite('T4_Sync_f=20.wav',sync20,fs);
%sound(sync4,fs);

[Pxx20,w20] = periodogram(sync20,[], 512, fs);
[Pxx0,w0] = periodogram(x,[], 512, fs);


%N=6,LPF=50Hz
sync50=[zeros(1,length(sig))]';
[LPF_b,LPF_a]=butter(4,50/(fs/2));
for i=1:6
    [l,h]=getFreq(6,i);
    [BP4_b,BP4_a]=butter(4,[l,h]/(fs/2));
    y4=abs(filter(BP4_b,BP4_a,sig));
    enve4=filter(LPF_b,LPF_a,y4);
    n=1:length(y4);dt=n/fs;f1=(l+h)/2;
    sin1=sin(2*pi*f1*dt)';
    enve4=enve4/norm(enve4)*norm(sig);
    sync50=sync50+enve4.*sin1;
end
sync50=sync50/norm(sync50)*norm(sig);
%plot(sync4);
audiowrite('T4_Sync_f=50.wav',sync50,fs);
%sound(sync4,fs);

[Pxx50,w50] = periodogram(sync50,[], 512, fs);

%N=4,LPF=100Hz
sync100=[zeros(1,length(sig))]';
[LPF_b,LPF_a]=butter(4,100/(fs/2));
for i=1:6
    [l,h]=getFreq(6,i);
    [BP4_b,BP4_a]=butter(4,[l,h]/(fs/2));
    y4=abs(filter(BP4_b,BP4_a,sig));
    enve4=filter(LPF_b,LPF_a,y4);
    n=1:length(y4);dt=n/fs;f1=(l+h)/2;
    sin1=sin(2*pi*f1*dt)';
    enve4=enve4/norm(enve4)*norm(sig);
    sync100=sync100+enve4.*sin1;
end
sync100=sync100/norm(sync100)*norm(sig);
%plot(sync4);
audiowrite('T4_Sync_f=100.wav',sync100,fs);
%sound(sync4,fs);

[Pxx100,w100] = periodogram(sync100,[], 512, fs);


%N=4,LPF=400Hz
sync400=[zeros(1,length(sig))]';
[LPF_b,LPF_a]=butter(4,400/(fs/2));
for i=1:6
    [l,h]=getFreq(6,i);
    [BP4_b,BP4_a]=butter(4,[l,h]/(fs/2));
    y4=abs(filter(BP4_b,BP4_a,sig));
    enve4=filter(LPF_b,LPF_a,y4);
    n=1:length(y4);dt=n/fs;f1=(l+h)/2;
    sin1=sin(2*pi*f1*dt)';
    enve4=enve4/norm(enve4)*norm(sig);
    sync400=sync400+enve4.*sin1;
end
sync400=sync400/norm(sync400)*norm(sig);
%plot(sync4);
audiowrite('T4_Sync_f=400.wav',sync400,fs);
%sound(sync4,fs);

[Pxx400,w400] = periodogram(sync400,[], 512, fs);

figure;
subplot(411)
plot(x)
title('Original Signal')
xlabel('Time')
subplot(412)
plot(sync400)
title('Result COF = 400Hz,N = 6')
xlabel('Time')
subplot(413)
plot(w0,10*log10(Pxx0))
title('Original Signal PSD')
xlabel('Frequency')
ylabel('Magnitude(dB)')
subplot(414)
plot(w400,10*log10(Pxx400))
title('Resulted PSD')
xlabel('Frequency')
ylabel('Magnitude(dB)')

% figure;
% subplot(5,1,1)
% plot(x)
% title('Original Signal')
% subplot(5,1,2)
% plot(sync20)
% title('COF = 20')
% subplot(5,1,3)
% plot(sync50)
% title('COF = 50')
% subplot(5,1,4)
% plot(sync100)
% title('COF = 100')
% subplot(5,1,5)
% plot(sync400)
% title('COF = 400')

% figure;
% subplot(5,1,1)
% plot(w0,10*log10(Pxx0))
% title('Original Signal PSD')
% subplot(5,1,2)
% plot(w20,10*log10(Pxx20))
% title('COF = 20Hz')
% subplot(5,1,3)
% plot(w50,10*log10(Pxx50))
% title('COF = 50Hz')
% subplot(5,1,4)
% plot(w100,10*log10(Pxx100))
% title('COF = 100Hz')
% subplot(5,1,5)
% plot(w400,10*log10(Pxx400))
% title('COF = 400Hz')

