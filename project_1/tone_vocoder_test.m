clear
close all
[x, Fs] = audioread('C_01_01.wav');

% ================================

% Task - 1
Fc = 50;
N1_50 = tone_vocoder(x, Fs, 1, Fc);
audiowrite('N1_50.wav', N1_50, Fs);
subplot(4, 1, 1)
plot(N1_50)
title('N = 1, f_{cut} = 50Hz')

N2_50 = tone_vocoder(x, Fs, 2, Fc);
audiowrite('N2_50.wav', N2_50, Fs);
subplot(4, 1, 2)
plot(N2_50)
title('N = 2, f_{cut} = 50Hz')

N4_50 = tone_vocoder(x, Fs, 4, Fc);
audiowrite('N4_50.wav', N4_50, Fs);
subplot(4, 1, 3)
plot(N4_50)
title('N = 4, f_{cut} = 50Hz')

N8_50 = tone_vocoder(x, Fs, 8, Fc);
audiowrite('N8_50.wav', N8_50, Fs);
subplot(4, 1, 4)
plot(N8_50)
title('N = 8, f_{cut} = 50Hz')

% ================================

% Task - 2
figure
N = 4;
N4_20 = tone_vocoder(x, Fs, N, 20);
audiowrite('N4_20.wav', N4_20, Fs);
subplot(4, 1, 1)
plot(N4_20)
title('N = 4, f_{cut} = 20Hz')

N4_50 = tone_vocoder(x, Fs, N, 50);
audiowrite('N4_50.wav', N4_50, Fs);
subplot(4, 1, 2)
plot(N4_50)
title('N = 4, f_{cut} = 50Hz')

N4_100 = tone_vocoder(x, Fs, N, 100);
audiowrite('N4_100.wav', N4_100, Fs);
subplot(4, 1, 3)
plot(N4_100)
title('N = 4, f_{cut} = 100Hz')

N4_400 = tone_vocoder(x, Fs, N, 400);
audiowrite('N4_400.wav', N4_400, Fs);
subplot(4, 1, 4)
plot(N4_400)
title('N = 4, f_{cut} = 400Hz')

% ================================

% generate ssn
[pxx, w] = periodogram(x, [], 512, Fs);
b = fir2(3000, w / (Fs / 2), sqrt(pxx / max(pxx)));
noise = 1 - 2 * rand(length(x), 1);
ssn = filter(b, 1, noise);
snr = 20 * log10(norm(x) / norm(ssn * norm(x) / norm(ssn) * 10^(1/4)));
y = x + 10^(-1/4) * ssn;
y = y / norm(y) * norm(x);

% ================================

% Task - 3
Fc = 50;
figure

N2_50_n = tone_vocoder(y, Fs, 2, Fc);
audiowrite('N2_50_n.wav', N2_50_n, Fs);
subplot(5, 1, 1)
plot(N2_50_n)
title('N = 2, f_{cut} = 50Hz')

N4_50_n = tone_vocoder(y, Fs, 4, Fc);
audiowrite('N4_50.wav', N4_50_n, Fs);
subplot(5, 1, 2)
plot(N4_50_n)
title('N = 4, f_{cut} = 50Hz')

N6_50_n = tone_vocoder(y, Fs, 6, Fc);
audiowrite('N6_50_n.wav', N6_50_n, Fs);
subplot(5, 1, 3)
plot(N6_50_n)
title('N = 6, f_{cut} = 50Hz')

N8_50_n = tone_vocoder(y, Fs, 8, Fc);
audiowrite('N8_50_n.wav', N8_50_n, Fs);
subplot(5, 1, 4)
plot(N8_50_n)
title('N = 8, f_{cut} =50Hz')

N16_50_n = tone_vocoder(y, Fs, 16, Fc);
audiowrite('N16_50_n.wav', N16_50_n, Fs);
subplot(5, 1, 5)
plot(N16_50_n)
title('N = 16, f_{cut} = 50Hz')


% ================================

% Task - 4
N = 6;
figure
title('With speech shape noise, N = 6')

N6_20_n = tone_vocoder(y, Fs, N, 20);
audiowrite('N6_20_n.wav', N6_20_n, Fs);
subplot(4, 1, 1)
plot(N6_20_n)
title('N = 6, f_{cut} = 20Hz')

N6_50_n = tone_vocoder(y, Fs, N, 50);
audiowrite('N6_50_n.wav', N6_50_n, Fs);
subplot(4, 1, 2)
plot(N6_50_n)
title('N = 6, f_{cut} = 50Hz')

N6_100_n = tone_vocoder(y, Fs, N, 100);
audiowrite('N6_100_n.wav', N6_100_n, Fs);
subplot(4, 1, 3)
plot(N6_100_n)
title('N = 6, f_{cut} = 100Hz')

N6_400_n = tone_vocoder(y, Fs, N, 400);
audiowrite('N6_400_n.wav', N6_400_n, Fs);
subplot(4, 1, 4)
plot(N6_400_n)
title('N = 6, f_{cut} = 400Hz')
