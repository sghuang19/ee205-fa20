close all

% Task 1 PSD
[pxx, w] = periodogram(N1_50, [], 512, Fs);
subplot(4, 1, 1)
semilogy(w, pxx)
title('N = 1, f_{cut} = 50Hz')
xlabel('frequency')
ylabel('PSD/dB')

[pxx, w] = periodogram(N2_50, [], 512, Fs);
subplot(4, 1, 2)
semilogy(w, pxx)
title('N = 2, f_{cut} = 50Hz')
xlabel('frequency')
ylabel('PSD/dB')

[pxx, w] = periodogram(N4_50, [], 512, Fs);
subplot(4, 1, 3)
semilogy(w, pxx)
title('N = 4, f_{cut} = 50Hz')
xlabel('frequency')
ylabel('PSD/dB')

[pxx, w] = periodogram(N8_50, [], 512, Fs);
subplot(4, 1, 4)
semilogy(w, pxx)
title('N = 8, f_{cut} = 50Hz')
xlabel('frequency')
ylabel('PSD/dB')

% ================================

% Task 2 PSD
figure

[pxx, w] = periodogram(N4_20, [], 512, Fs);
subplot(4, 1, 1)
semilogy(w, pxx)
title('N = 4, f_{cut} = 20Hz')
xlabel('frequency')
ylabel('PSD/dB')

[pxx, w] = periodogram(N4_50, [], 512, Fs);
subplot(4, 1, 2)
semilogy(w, pxx)
title('N = 4, f_{cut} = 50Hz')
xlabel('frequency')
ylabel('PSD/dB')

[pxx, w] = periodogram(N4_100, [], 512, Fs);
subplot(4, 1, 3)
semilogy(w, pxx)
title('N = 4, f_{cut} = 100Hz')
xlabel('frequency')
ylabel('PSD/dB')

[pxx, w] = periodogram(N4_400, [], 512, Fs);
subplot(4, 1, 4)
semilogy(w, pxx)
title('N = 4, f_{cut} = 400Hz')
xlabel('frequency')
ylabel('PSD/dB')

% ================================

% Task 3 PSD
figure

[pxx, w] = periodogram(N2_50_n, [], 512, Fs);
subplot(5, 1, 1)
semilogy(w, pxx)
title('N = 2, f_{cut} = 50Hz')
xlabel('frequency')
ylabel('PSD/dB')

[pxx, w] = periodogram(N4_50_n, [], 512, Fs);
subplot(5, 1, 2)
semilogy(w, pxx)
title('N = 4, f_{cut} = 50Hz')
xlabel('frequency')
ylabel('PSD/dB')

[pxx, w] = periodogram(N6_50_n, [], 512, Fs);
subplot(5, 1, 3)
semilogy(w, pxx)
title('N = 6, f_{cut} = 50Hz')
xlabel('frequency')
ylabel('PSD/dB')

[pxx, w] = periodogram(N8_50_n, [], 512, Fs);
subplot(5, 1, 4)
semilogy(w, pxx)
title('N = 8, f_{cut} = 50Hz')
xlabel('frequency')
ylabel('PSD/dB')

[pxx, w] = periodogram(N16_50_n, [], 512, Fs);
subplot(5, 1, 5)
semilogy(w, pxx)
title('N = 8, f_{cut} = 50Hz')
xlabel('frequency')
ylabel('PSD/dB')

% ================================

% Task 4 PSD
figure

[pxx, w] = periodogram(N6_20_n, [], 512, Fs);
subplot(4, 1, 1)
semilogy(w, pxx)
title('N = 6, f_{cut} = 20Hz')
xlabel('frequency')
ylabel('PSD/dB')

[pxx, w] = periodogram(N6_50_n, [], 512, Fs);
subplot(4, 1, 2)
semilogy(w, pxx)
title('N = 6, f_{cut} = 50Hz')
xlabel('frequency')
ylabel('PSD/dB')

[pxx, w] = periodogram(N6_100_n, [], 512, Fs);
subplot(4, 1, 3)
semilogy(w, pxx)
title('N = 6, f_{cut} = 100Hz')
xlabel('frequency')
ylabel('PSD/dB')

[pxx, w] = periodogram(N6_400_n, [], 512, Fs);
subplot(4, 1, 4)
semilogy(w, pxx)
title('N = 6, f_{cut} = 400Hz')
xlabel('frequency')
ylabel('PSD/dB')
