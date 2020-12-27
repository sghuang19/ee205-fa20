%% constants definition
% length of signal
N = 32;
% length of cp added
lcp = 4;
% sampling interval
T = 1e-6;
% carrier signal frequency
wc = 100e6;
% time-step
dt = 1e-9;
% impulse series
delta = [1, zeros(1, 999)];
% for square series
c = ones(1, 999);

%% Block 1
% set real and imaginary part of signal
xr = sqrt(2) * round(rand(1, N)) - sqrt(2) / 2;
xi = sqrt(2) * round(rand(1, N)) - sqrt(2) / 2;

% plot the real and imaginary part of the signal separately
figure(1)
subplot(211)
stem(0:N - 1, xr)
xlabel('n');
ylabel('\Re\{x[n]\}')
title('Real part of input serial signal')

subplot(212);
stem(0:N - 1, xi)
xlabel('n')
ylabel('\Im\{x[n]\}')
title('Imaginary part of input serial signal')

% load X in frequency domain and construct time domain signal x by X
X = xr + 1i * xi;
x = ifft(X);

figure(2)
subplot(211)
stem(0:N - 1, real(x))
xlabel('n')
title('Real part of frequency-domain-loaded parallel input signal')

subplot(212);
stem(0:N - 1, imag(x))
xlabel('n')
title('Imaginary part of frequency-domain-loaded parallel input signal')

% add cyclic prefix
x_cp = [x(N - lcp + 1:N), x];

figure(3);
subplot(211);
stem(-lcp:N - 1, real(x_cp))
xlabel('n')
title('Real part of frequency-domain-loaded parallel input signal with cyclic prefix')

subplot(212);
stem(-lcp:N - 1, imag(x_cp))
xlabel('n')
title('Imaginary part of frequency-domain-loaded parallel input signal with cyclic prefix')

% DAC, create impulse and square series
x_cp_ct = upsample(x_cp, 1000);
x_sq = reshape(repmat(x_cp, 1000, 1), 1, []);

figure(4)
subplot(211)
plot((1:length(x_cp_ct)) * dt, real(x_cp_ct))
xlabel('t')
title('Impulse series converted CT signal')

subplot(212)
plot((1:length(x_sq)) * dt, real(x_sq))
xlabel('n')
title('Zero-order-held CT signal')

% amplitude modulation
t = (1:length(x_sq)) * dt;
sin1 = sin(2 * pi * wc * t); cos1 = cos(2 * pi * wc * t);
x_am = cos1 .* real(x_sq) + sin1 .* imag(x_sq);
% spectrum
xtw = fft(x_am) / length(x_am);
X_am = abs(fftshift(xtw));
n = wc * (0:2:length(X_am) / 2) / (length(X_am) / 2.5);

figure(5)
subplot(211)
plot((1:length(x_am)) * dt, x_am)
xlabel('t')
title('CT AM signal')

subplot(212)
stem(n, X_am(1:2:length(X_am) / 2 + 1))
axis([0.97 * 10^8 1.03 * 10^8 0 0.025])
xlabel('f')
title('Frequency spectrum of CT AM signal')

%% Transmition part
A = 1;
B = [0.5 zeros(1, 1.5 * 1000 - 1) 0.4 zeros(1, 1000 - 1) 0.35 zeros(1, 0.5 * 1000 - 1) 0.3];
h = [0.5, zeros(1, 1499), 0.4, zeros(1, 999), 0.35, zeros(1, 499), 0.3, zeros(1, 1000)];
yh = filter(B, A, x_am);

figure(6)
subplot(211)
plot((0:length(yh) - 1) * dt, yh)
xlabel('t')
ylabel('y_h(t)')
title('Transmitted CT signal')

subplot(212)
plot((0:length(h) - 1) * dt, h)
xlabel('t')
ylabel('h(t)')
title('h(t)')

%% Receive and demodulate
t2 = (1:length(yh)) * dt;
ytr = 2 * cos(2 * pi * wc * t2) .* yh;
yti = 2 * sin(2 * pi * wc * t2) .* yh;

% define ideal LPF and pass signal through which
ft1 = fft(ytr);
ft2 = fft(yti);
ft1 = [ft1(1:2000), zeros(1, length(ft1) - 4000), ft1(length(ft1) - 2000 + 1:length(ft1))];
ft2 = [ft2(1:2000), zeros(1, length(ft2) - 4000), ft2(length(ft2) - 2000 + 1:length(ft2))];

ytrc = ifft(ft1);
ytic = ifft(ft2);

figure(7)
subplot(211)
plot((1:length(ytrc)) * dt, ytrc)
xlabel('n')
ylabel('\Re\{y(t)\}')
title('Real part of received signal')

subplot(212)
plot((1:length(ytic)) * dt, ytic)
xlabel('n')
ylabel('\Im\{y(t)\}')
title('Imaginary part of received signal')

% take each segment's average to build Y
Nx = N + lcp;
Yr = zeros(1, Nx);
Yi = zeros(1, Nx);

for i = 1:Nx
    re = 0; im = 0;

    for j = (i - 1) * 1000 + 1:i * 1000
        re = re + ytrc(j);
        im = im + ytic(j);
    end

    Yr(i) = re / 1000;
    Yi(i) = im / 1000;
end

Y = Yr + 1i * Yi;

figure(8)
subplot(211)
stem(1:Nx, Yr)
xlabel('n')
ylabel('\Re\{Y[n]\}')
title('Real part of Y')

subplot(212)
stem(1:Nx, Yi)
xlabel('n')
ylabel('\Im\{Y[n]\}')
title('Imaginary part of Y')

% obtain the fft after removing cyclic prefix
Y_rc = Y(lcp + 1:Nx);
Y_recover_N = fft(Y_rc);

figure(9)
subplot(211)
stem(real(Y_recover_N))
xlabel('n')
legend('recovered real part of Y')

subplot(212);
stem(imag(Y_recover_N))
xlabel('n');
legend('recovered imaginary part pf Y')

% Y / H = X
X_recover_N = Y_recover_N ./ H;

figure(10)
subplot(211)
stem(real(X_recover_N), '*')
hold on
stem(xr)
xlabel('n')
legend('\Re\{x_{recover}[n]\}', '\Re\{x[n]\}')
hold off

subplot(212)
stem(imag(X_recover_N), '*')
hold on
stem(xi)
xlabel('n')
legend('\Im\{x_{recover}[n]\}', '\Im\{x[n]\}')
