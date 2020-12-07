[x,fs]=audioread('C_01_01.wav');
[Pxx,w]=periodogram(x,[],512,fs);
b=fir2(3000,w/(fs/2),sqrt(Pxx/max(Pxx)));
noise=1-2*rand(1,length(x));
SSN=filter(b,1,noise)';
SSN=SSN/norm(SSN)*norm(x)*10^(0.25);%adjust intensity of SSN;
sig=x+SSN;
sig=sig/norm(sig)*norm(x);


%Fix LPF=50Hz and vary number of parallel bands 
n=1;
A=[1 2 4 6 8];
for i=1:5
    res=vocoder(50,A(i),x,fs);
    %audiowrite(strcat('LPF100_n',sprintf('%d',n),'_raw.wav'),res,fs);
    [Pyy,wh]=periodogram(res,[],512,fs);
    figure;
    subplot(412);plot(res);
    xlabel('Time');ylabel('output');
    title(strcat('N=',sprintf('%d',A(i))));
    subplot(411);plot(x);
      xlabel('Time');ylabel('output');
    title('original signal');
    subplot(414); plot(wh,10*log10(Pyy));
      xlabel('Frequency');ylabel('PSD');
    title(strcat('PSD of N=',sprintf('%d',A(i))));
    subplot(413);plot(w,10*log10(Pxx));
      xlabel('Frequency');ylabel('PSD');
    title('PSD of original signal');
end

%task2
%Fix parallel bands=12 and vary LPF 
B=[20 50 100 400];
for i=1:4
    res=vocoder(B(i),4,x,fs);
    %audiowrite(strcat('LPF',sprintf('%d',h),'_n=12_raw.wav'),res,fs);
    [Pyy,wh]=periodogram(res,[],512,fs);
    figure;
    subplot(412);plot(res);
    xlabel('Time');ylabel('output');
    title(strcat('f_c_u_t=',sprintf('%d',B(i))));
    subplot(411);plot(x);
      xlabel('Time');ylabel('output');
    title('original signal');
    subplot(414); plot(wh,10*log10(Pyy));
      xlabel('Frequency');ylabel('PSD(dB)');
    title(strcat('PSD of f_c_u_t=',sprintf('%d',B(i))));
    subplot(413);plot(w,10*log10(Pxx));
      xlabel('Frequency');ylabel('PSD(dB)');
    title('PSD of original signal');
end
%we find that with a big N,the increase in LPF dont't make too much changes

%Fix parallel bands*LPF=1200 
h=50;
for i=1:6
    res=vocoder(h,ceil(1000/h),x,fs);
    %audiowrite(strcat('LPF',sprintf('%d',h),'_n=',sprintf('%d',ceil(600/h)),'_raw.wav'),res,fs);
    h=h*2;
end
%By varying the product,we find though it's not the same,we can understand
%the meaing.And the Threshold may be 1000

%task3
%Now we add the noise and find what will happen
%Fix LPF=i00Hz and vary number of parallel bands 

for i=1:5
    res=vocoder(50,A(i),sig,fs);
    %audiowrite(strcat('LPF100_n',sprintf('%d',n),'_edited.wav'),res,fs);
    [Pyy,wh]=periodogram(res,[],512,fs);
    figure;
    subplot(412);plot(res);
    xlabel('Time');ylabel('output');
    title(strcat('N=',sprintf('%d',A(i))));
    subplot(411);plot(x);
      xlabel('Time');ylabel('output');
    title('original speech shaped noise');
    subplot(414); plot(wh,10*log10(Pyy));
      xlabel('Frequency');ylabel('PSD');
    title(strcat('PSD of N=',sprintf('%d',A(i))));
    subplot(413);plot(w,10*log10(Pxx));
      xlabel('Frequency');ylabel('PSD');
    title('PSD of original speech shaped noise');
end
%larger n,clearer the voice

%Fix parallel bands=12 and vary LPF 

for i=1:4
    res=vocoder(B(i),4,sig,fs);
    %audiowrite(strcat('LPF',sprintf('%d',h),'_n=12_edited.wav'),res,fs);
    [Pyy,wh]=periodogram(res,[],512,fs);
    figure;
    subplot(412);plot(res);
    xlabel('Time');ylabel('output');
    title(strcat('f_c_u_t=',sprintf('%d',B(i))));
    subplot(411);plot(x);
      xlabel('Time');ylabel('output');
    title('original speech shaped noise');
    subplot(414); plot(wh,10*log10(Pyy));
      xlabel('Frequency');ylabel('PSD(dB)');
    title(strcat('PSD of f_c_u_t=',sprintf('%d',B(i))));
    subplot(413);plot(w,10*log10(Pxx));
      xlabel('Frequency');ylabel('PSD(dB)');
    title('PSD of original speech shaped noise');speech shaped noisespeech shaped noise
end
%roughly the voice don't change too much with the increase of LPF,while the
%noise gets noiser,which means we needn't make the LPF too high

%Fix parallel bands*LPF=2400 
h=50;
for i=1:6
    res=vocoder(h,ceil(2400/h),sig,fs);
    audiowrite(strcat('LPF',sprintf('%d',h),'_n=',sprintf('%d',ceil(2400/h)),'_edited.wav'),res,fs);
    h=h*2;
end
%By varying the product,we find though it's not the same,we can understand
%the meaing.And the Threshold may be 2400.
%when there's noise,the N matters more than LPF,that means with larger
%N,we can understand the sentence with lower LPF*N.
%The reason for the phenomena may be that with lower LPF,we can neturalize
%more noise part and make the speech dominant,and we should ensure the
%LPF*N is larger than the threshold,so we need a larger N.

