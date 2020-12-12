[x,fs]=audioread('C_01_01.wav');
[Pxx,w]=periodogram(x,[],512,fs);
b=fir2(3000,w/(fs/2),sqrt(Pxx/max(Pxx)));
noise=1-2*rand(1,length(x));
SSN=filter(b,1,noise)';
SSN=SSN/norm(SSN)*norm(x)*10^(0.25);%adjust intensity of SSN;
sig=x+SSN;
sig=sig/norm(sig)*norm(x);


[LPF_b,LPF_a]=butter(4,50/(fs/2));
%Set BandPass Filter and operate
%N=1
[BP1_b,BP1_a]=butter(4,[200,7000]/(fs/2));
y1=abs(filter(BP1_b,BP1_a,sig));
enve1=filter(LPF_b,LPF_a,y1);
n=1:length(y1);dt=n/fs;f1=(200+7000)/2;
sin1=sin(2*pi*f1*dt)';
sync1=enve1.*sin1;
sync1=sync1/norm(sync1)*norm(sig);
audiowrite('T3_Sync_N=1.wav',sync1,fs);
%plot(sync1);
%sound(sync1,fs);
[Pxx1,w1] = periodogram(sync1,[], 512, fs);
[Pxx0,w0] = periodogram(x,[], 512, fs);


%N=2
sync2=[zeros(1,length(sig))]';
for i=1:2
    [l,h]=getFreq(2,i);
    [BP2_b,BP2_a]=butter(4,[l,h]/(fs/2));
    y2=abs(filter(BP2_b,BP2_a,sig));
    enve2=filter(LPF_b,LPF_a,y2);
    n=1:length(y2);dt=n/fs;f1=(l+h)/2;
    sin1=sin(2*pi*f1*dt)';
    enve2=enve2/norm(enve2)*norm(sig);
    sync2=sync2+enve2.*sin1;
end
sync2=sync2/norm(sync2)*norm(sig);
audiowrite('T3_Sync_N=2.wav',sync2,fs);
%plot(sync2);
%sound(sync2,fs);
[Pxx2,w2] = periodogram(sync2,[], 512, fs);


%N=4
sync4=[zeros(1,length(sig))]';
for i=1:4
    [l,h]=getFreq(4,i);
    [BP4_b,BP4_a]=butter(4,[l,h]/(fs/2));
    y4=abs(filter(BP4_b,BP4_a,sig));
    enve4=filter(LPF_b,LPF_a,y4);
    n=1:length(y4);dt=n/fs;f1=(l+h)/2;
    sin1=sin(2*pi*f1*dt)';
    enve4=enve4/norm(enve4)*norm(sig);
    sync4=sync4+enve4.*sin1;
end
sync4=sync4/norm(sync4)*norm(sig);
%plot(sync4);
audiowrite('T3_Sync_N=4.wav',sync4,fs);
%sound(sync4,fs);

[Pxx4,w4] = periodogram(sync4,[], 512, fs);


%N=6
sync6=[zeros(1,length(sig))]';
for i=1:6
    [l,h]=getFreq(6,i);
    [BP6_b,BP6_a]=butter(4,[l,h]/(fs/2));
    y6=abs(filter(BP6_b,BP6_a,sig));
    enve6=filter(LPF_b,LPF_a,y6);
    n=1:length(y6);dt=n/fs;f1=(l+h)/2;
    sin1=sin(2*pi*f1*dt)';
    enve6=enve6/norm(enve6)*norm(sig);
    sync6=sync6+enve6.*sin1;
end
sync6=sync6/norm(sync6)*norm(sig);
%plot(sync6);
audiowrite('T3_Sync_N=6.wav',sync6,fs);
%sound(sync6,fs);

[Pxx6,w6] = periodogram(sync6,[], 512, fs);



%N=8
sync8=[zeros(1,length(sig))]';
for i=1:8
    [l,h]=getFreq(8,i);
    [BP8_b,BP8_a]=butter(4,[l,h]/(fs/2));
    y8=abs(filter(BP8_b,BP8_a,sig));
    enve8=filter(LPF_b,LPF_a,y8);
    n=1:length(y8);dt=n/fs;f1=(l+h)/2;
    sin1=sin(2*pi*f1*dt)';
    enve8=enve8/norm(enve8)*norm(sig);
    sync8=sync8+enve8.*sin1;
end
sync8=sync8/norm(sync8)*norm(sig);
%plot(sync8);
audiowrite('T3_Sync_N=8.wav',sync8,fs);
%sound(sync8,fs);

[Pxx8,w8] = periodogram(sync8,[], 512, fs);


%N=16
sync16=[zeros(1,length(sig))]';
for i=1:16
    [l,h]=getFreq(16,i);
    [BP16_b,BP16_a]=butter(4,[l,h]/(fs/2));
    y16=abs(filter(BP16_b,BP16_a,sig));
    enve16=filter(LPF_b,LPF_a,y16);
    n=1:length(y16);dt=n/fs;f1=(l+h)/2;
    sin1=sin(2*pi*f1*dt)';
    enve16=enve16/norm(enve16)*norm(sig);
    sync16=sync16+enve16.*sin1;
end
sync16=sync16/norm(sync16)*norm(sig);
%plot(sync6);
audiowrite('T3_Sync_N=16.wav',sync16,fs);
%sound(sync6,fs);

[Pxx16,w16] = periodogram(sync16,[], 512, fs);

figure;
subplot(411)
plot(x)
title('Original Signal')
xlabel('Time')
subplot(412)
plot(sync16)
title('Result COF = 50Hz,N = 16')
xlabel('Time')
subplot(413)
plot(w0,10*log10(Pxx0))
title('Original Signal PSD')
xlabel('Frequency')
ylabel('Magnitude(dB)')
subplot(414)
plot(w16,10*log10(Pxx16))
title('Resulted PSD')
xlabel('Frequency')
ylabel('Magnitude(dB)')

% figure;
% subplot(6,1,1)
% plot(w1,10*log10(Pxx1))
% title('N = 1')
% subplot(6,1,2)
% plot(w2,10*log10(Pxx2))
% title('N = 2')
% subplot(6,1,3)
% plot(w4,10*log10(Pxx4))
% title('N = 4')
% subplot(6,1,4)
% plot(w6,10*log10(Pxx6))
% title('N = 6')
% subplot(6,1,5)
% plot(w8,10*log10(Pxx8))
% title('N = 8')
% subplot(6,1,6)
% plot(w16,10*log10(Pxx16))
% title('N = 16')