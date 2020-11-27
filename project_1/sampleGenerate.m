[x,fs]=audioread('C_01_01.wav');
[Pxx,w]=periodogram(x,[],512,fs);
b=fir2(3000,w/(fs/2),sqrt(Pxx/max(Pxx)));
noise=1-2*rand(1,length(x));
SSN=filter(b,1,noise)';
SSN=SSN/norm(SSN)*norm(x)*10^(0.25);%adjust intensity of SSN;
sig=x+SSN;
sig=sig/norm(sig)*norm(x);

%Fix LPF=i00Hz and vary number of parallel bands 
n=1;
for i=1:7
    res=vocoder(100,n,x,fs);
    %audiowrite(strcat('LPF100_n',sprintf('%d',n),'_raw.wav'),res,fs);
    n=n*2;
end

%Fix parallel bands=12 and vary LPF 
h=100;
for i=1:7
    res=vocoder(h,12,x,fs);
    %audiowrite(strcat('LPF',sprintf('%d',h),'_n=12_raw.wav'),res,fs);
    h=h*2;
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

%Now we add the noise and find what will happen
%Fix LPF=i00Hz and vary number of parallel bands 
n=1;
for i=1:7
    res=vocoder(100,n,sig,fs);
    %audiowrite(strcat('LPF100_n',sprintf('%d',n),'_edited.wav'),res,fs);
    n=n*2;
end
%larger n,clearer the voice

%Fix parallel bands=12 and vary LPF 
h=100;
for i=1:7
    res=vocoder(h,12,sig,fs);
    %audiowrite(strcat('LPF',sprintf('%d',h),'_n=12_edited.wav'),res,fs);
    h=h*2;
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

