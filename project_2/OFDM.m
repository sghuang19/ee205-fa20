% Constants definition
N=32;   % N is the length of Signal
lcp=4;  % lcp is the length of adding cp
T=10^(-6);    % T is the sample period
wc=100*10^6;    % wc is carrier Frequency
dt=10^(-9);    % dt is a small time period
delta=[1,zeros(1,999)]; % delta is the impulse function
c=ones(1,999);  % c is the function to create square wave
% Block 1
% set real and imaginary part of signal
xr=sqrt(2)*round(rand(1,N))-sqrt(2)/2;
xi=sqrt(2)*round(rand(1,N))-sqrt(2)/2;
% plot the signal separately
figure(1);
subplot(211);
stem(0:N-1,xr);
xlabel('n');ylabel('real[x]');
title('real part of input signal');
subplot(212);
stem(0:N-1,xi);
xlabel('n');ylabel('imag[x]');
title('imaginary part of input signal');
% take X as spectral data and construct time domain signal x by X;
X=xr+1i*xi;
x=ifft(X);

figure(2);
subplot(211);
stem(0:N-1,real(x));
xlabel('n');
ylabel('real OFDM');
title('real part of OFDM signal');
subplot(212);
stem(0:N-1,imag(x));
xlabel('n');
ylabel('imag OFDM');
title('imaginary part of OFDM signal');

% add CP
x_cp=[x(N-lcp+1:N),x];

figure(3);
subplot(211);
stem(-lcp:N-1,real(x_cp));
xlabel('n');ylabel('real OFDM with CP');
title('real part of OFDM signal with CP');
subplot(212);
stem(-lcp:N-1,imag(x_cp));
xlabel('n');ylabel('imag OFDM with CP');
title('imaginary part of OFDM signal with CP');

% Now we do DAC, create impulse and square
x_cp_ct=upsample(x_cp,1000);
x_sq=reshape(repmat(x_cp,1000,1),1,[]);

figure(4);
subplot(211);
plot((1:length(x_cp_ct))*dt,real(x_cp_ct));
xlabel('t');
ylabel('Pulse');
title('CT signal pulse');
subplot(212);
plot((1:length(x_sq))*dt,real(x_sq));
xlabel('n');
ylabel('intensity');
title('CT signal square');

% AM process
t=(1:length(x_sq))*dt;
sin1=sin(2*pi*wc*t);cos1=cos(2*pi*wc*t);
x_am=cos1.*real(x_sq)+sin1.*imag(x_sq);
%Freq
xtw = fft(x_am)/length(x_am);
X_am=abs(fftshift(xtw));
n=wc*(0:2:length(X_am)/2)/(length(X_am)/2.5);

figure(5);
subplot(211);
plot((1:length(x_am))*dt,x_am);
xlabel('t');
ylabel('intensity');
title('CT AM signal');
subplot(212)
stem(n,X_am(1:2:length(X_am)/2+1));
axis([0.97*10^8 1.03*10^8 0 0.025]);
xlabel('f')
ylabel('Freq.')
title('Frequency of CT AM signal')

% Transmit Part
A=1;
B=[0.5 zeros(1,1.5*1000-1) 0.4 zeros(1,1000-1) 0.35 zeros(1,0.5*1000-1) 0.3 ];
h=[0.5,zeros(1,1499),0.4,zeros(1,999),0.35,zeros(1,499),0.3,zeros(1,1000)];
yh=filter(B,A,x_am);

figure(6);
subplot(211);
plot((0:length(yh)-1)*dt,yh);
xlabel('t');ylabel('yh(t)');
title('CT transmit signal');
subplot(212);
plot((0:length(h)-1)*dt,h);
xlabel('n');ylabel('h(t)');
title('h(t)');

% Receive and remodulate

t2=(1:length(yh))*dt;
ytr=2*cos(2*pi*wc*t2).*yh;
yti=2*sin(2*pi*wc*t2).*yh;

%set ideal LPF and pass signal through it
fft1=fft(ytr);
fft2=fft(yti);
fft1=[fft1(1:2000),zeros(1,length(fft1)-4000),fft1(length(fft1)-2000+1:length(fft1))];
fft2=[fft2(1:2000),zeros(1,length(fft2)-4000),fft2(length(fft2)-2000+1:length(fft2))];


ytrc=ifft(fft1);
ytic=ifft(fft2);


figure(7);
subplot(211);
plot((1:length(ytrc))*dt,ytrc);
xlabel('n');ylabel('y(t)');
title('real part of Transmition');
subplot(212);
plot((1:length(ytic))*dt,ytic);
xlabel('n');ylabel('y(t)');
title('imaginary part of Transmition');

% now we take each segment's average to build Y
Nx=N+lcp;
Yr=zeros(1,Nx);
Yi=zeros(1,Nx);
for i=1:Nx
    re=0;im=0;
    for j=(i-1)*1000+1:i*1000
        re=re+ytrc(j);
        im=im+ytic(j);
    end
    Yr(i)=re/1000;
    Yi(i)=im/1000;
end
Y=Yr+1i*Yi;

figure(8);
subplot(211);
stem(1:Nx,Yr);
xlabel('n');ylabel('Y[n]');
title('real part of Y');
subplot(212);
stem(1:Nx,Yi);
xlabel('n');ylabel('Y[n]');
title('imaginary part of Y');

%求得去cp后y的fft
Y_rc=Y(lcp+1:Nx);
Y_recover_N=fft(Y_rc);

figure(9);
subplot(211);
stem(real(Y_recover_N));
xlabel('n');
legend('Y recover real');
subplot(212);
stem(imag(Y_recover_N));
xlabel('n');
legend('Y recover imag');

%Y/H=X
X_recover_N=Y_recover_N./H;

figure(10);
subplot(211);
stem(real(X_recover_N));
hold on;
stem(xr);
xlabel('n');legend('x_r_c_o_v_e_r[n] Real','x[n] Real');
hold off;
subplot(212);
stem(imag(X_recover_N));
hold on;
stem(xi);
xlabel('n');
hold off;
legend('x_r_c_o_v_e_r[n] Imag','x[n] Imag');




