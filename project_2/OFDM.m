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
xlabel('n');ylabel('real[n]');
title('real part of input signal');
subplot(212);
stem(0:N-1,xi);
xlabel('n');ylabel('imag[n]');
title('imaginary part of input signal');
% take X as spectral data and construct time domain signal x by X;
X=xr+1i*xi;
x=ifft(X);

figure(2);
subplot(211);
stem(0:N-1,real(x));
xlabel('n');ylabel('real OFDM');
title('real part of OFDM signal');
subplot(212);
stem(0:N-1,imag(x));
xlabel('n');ylabel('imag OFDM');
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
x_cp_ct=kron(x_cp,delta);
x_sq=kron(x_cp,c);

figure(4);
subplot(211);
plot((1:length(x_cp_ct))*dt,real(x_cp_ct));
xlabel('t');ylabel('Pulse');
title('CT signal pulse');
subplot(212);
plot((1:length(x_sq))*dt,real(x_sq));
xlabel('n');ylabel('intensity');
title('CT signal square');

% AM process
t=(1:length(x_sq))*dt;
sin1=sin(2*pi*wc*t);cos1=cos(2*pi*wc*t);
x_am=cos1.*real(x_sq)+sin1.*imag(x_sq);

figure(5);
plot((1:length(x_am))*dt,x_am);
xlabel('t');ylabel('intensity');
title('CT AM signal');

% Transmit Part
h=[0.5,zeros(1,1499),0.4,zeros(1,999),0.35,zeros(1,499),0.3,zeros(1,1000)];
yh=conv(x_am,h);

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

%set LPF and pass signal through it
[b,a]=butter(4,wc*dt*2);
ytrc=filter(b,a,ytr);
ytic=filter(b,a,yti);

figure(7);
subplot(211);
plot((1:length(ytrc))*dt,real(ytrc));
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
    for j=(i-1)*1000:i*1000
        re=re+ytrc(j+1);
        im=im+ytic(j+1);
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

h_dt=zeros(1,4);
for i=1:4
    tmp=0;
    for j=(i-1)*1000:i*1000-1
       tmp=tmp+h(j+1);
    end
    h_dt(i)=tmp;
end


