% Constants definition
N = 32; % N is the length of Signal
lcp = 4; % lcp is the length of adding cp
T = 10^(-6); % T is the sample period
wc = 100 * 10^6; % wc is carrier Frequency
dt = 10^(-9); % dt is a small time period
delta = [1, zeros(1, 999)]; % delta is the impulse function
c = ones(1, 999); % c is the function to create square wave
% Block 1
% set real and imaginary part of signal
xr = sqrt(2) * round(rand(1, N)) - sqrt(2) / 2; % 频域
xi = sqrt(2) * round(rand(1, N)) - sqrt(2) / 2;

% take X as spectral data and construct time domain signal x by X;
X = xr + 1i * xi;
x = ifft(X); % 得时域

% add CP
x_cp = [x(N - lcp + 1:N), x]; %时域上+cp

% Now we do DAC, create impulse and square
x_cp_ct = upsample(x_cp, 1000); % 转化成impulse
x_sq = reshape(repmat(x_cp, 1000, 1), 1, []); % 转化成方波

% AM process
t = (1:length(x_sq)) * dt;
sin1 = sin(2 * pi * wc * t);
cos1 = cos(2 * pi * wc * t);
x_am = cos1 .* real(x_sq) + sin1 .* imag(x_sq); % 加carrier

% Transmit Part
A = 1;
B = [0.5 zeros(1, 1.5 * 1000 - 1) 0.4 zeros(1, 1000 - 1) 0.35 zeros(1, 0.5 * 1000 - 1) 0.3];
h = [0.5, zeros(1, 1499), 0.4, zeros(1, 999), 0.35, zeros(1, 499), 0.3, zeros(1, 1000)]; % 空气传输
yh = filter(B, A, x_am);

% Receive and remodulate

t2 = (1:length(yh)) * dt;
ytr = 2 * cos(2 * pi * wc * t2) .* yh;
yti = 2 * sin(2 * pi * wc * t2) .* yh; % 恢复强度

%set ideal LPF and pass signal through it
fft1 = fft(ytr); % 变到频域
fft2 = fft(yti);
fft1 = [fft1(1:2000), zeros(1, length(fft1) - 4000), fft1(length(fft1) - 2000 + 1:length(fft1))];
fft2 = [fft2(1:2000), zeros(1, length(fft2) - 4000), fft2(length(fft2) - 2000 + 1:length(fft2))];

ytrc = ifft(fft1);
ytic = ifft(fft2);

% now we take each segment's average to build Y
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

%求得去cp后y的fft
Y_rc = Y(lcp + 1:Nx);
Y_recover_N = fft(Y_rc);

%两者比值得H
H = Y_recover_N ./ X;
