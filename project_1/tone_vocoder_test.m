clear
close all
[x, Fs] = audioread('C_01_01.wav');

% Task - 1
Fc = 50;
N1_50 = tone_vocoder(x, Fs, 1, Fc);
audiowrite('N1_50.wav', N1_50, Fs);
subplot(4, 1, 1)
plot(N1_50)

N2_50 = tone_vocoder(x, Fs, 2, Fc);
audiowrite('N2_50.wav', N2_50, Fs);
subplot(4, 1, 2)
plot(N2_50)

N4_50 = tone_vocoder(x, Fs, 4, Fc);
audiowrite('N4_50.wav', N4_50, Fs);
subplot(4, 1, 3)
plot(N4_50)

N8_50 = tone_vocoder(x, Fs, 8, Fc);
audiowrite('N8_50.wav', N8_50, Fs);
subplot(4, 1, 4)
plot(N8_50)

% Task - 2
