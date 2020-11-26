[x, fs] = audioread('C_01_01.wav');
[Pxx, w] = periodogram(x, [], 512, fs);
b = fir2(3000, w / (fs / 2), sqrt(Pxx / max(Pxx)));
noise = 1 - 2 * rand(1, length(x));
SSN = filter(b, 1, noise)';
SSN = SSN / norm(SSN) * norm(x) * 10^(0.25); %adjust intensity of SSN;
sig = x + SSN;
sig = sig / norm(sig) * norm(x);
%Set LPF and operate

%N=6,LPF=20Hz
sync4 = [zeros(1, length(sig))]';
[LPF_b, LPF_a] = butter(4, 20 / (fs / 2));

for i = 1:6
    [l, h] = getFreq(6, i);
    [BP4_b, BP4_a] = butter(4, [l, h] / (fs / 2));
    y4 = abs(filter(BP4_b, BP4_a, sig));
    enve4 = filter(LPF_b, LPF_a, y4);
    n = 1:length(y4); dt = n / fs; f1 = (l + h) / 2;
    sin1 = sin(2 * pi * f1 * dt)';
    enve4 = enve4 / norm(enve4) * norm(sig);
    sync4 = sync4 + enve4 .* sin1;
end

sync4 = sync4 / norm(sync4) * norm(sig);
%plot(sync4);
audiowrite('T4_Sync_f=20.wav', sync4, fs);
%sound(sync4,fs);

%N=4,LPF=50Hz
sync4 = [zeros(1, length(sig))]';
[LPF_b, LPF_a] = butter(4, 50 / (fs / 2));

for i = 1:6
    [l, h] = getFreq(6, i);
    [BP4_b, BP4_a] = butter(4, [l, h] / (fs / 2));
    y4 = abs(filter(BP4_b, BP4_a, sig));
    enve4 = filter(LPF_b, LPF_a, y4);
    n = 1:length(y4); dt = n / fs; f1 = (l + h) / 2;
    sin1 = sin(2 * pi * f1 * dt)';
    enve4 = enve4 / norm(enve4) * norm(sig);
    sync4 = sync4 + enve4 .* sin1;
end

sync4 = sync4 / norm(sync4) * norm(sig);
%plot(sync4);
audiowrite('T4_Sync_f=50.wav', sync4, fs);
%sound(sync4,fs);

%N=4,LPF=100Hz
sync4 = [zeros(1, length(sig))]';
[LPF_b, LPF_a] = butter(4, 100 / (fs / 2));

for i = 1:6
    [l, h] = getFreq(6, i);
    [BP4_b, BP4_a] = butter(4, [l, h] / (fs / 2));
    y4 = abs(filter(BP4_b, BP4_a, sig));
    enve4 = filter(LPF_b, LPF_a, y4);
    n = 1:length(y4); dt = n / fs; f1 = (l + h) / 2;
    sin1 = sin(2 * pi * f1 * dt)';
    enve4 = enve4 / norm(enve4) * norm(sig);
    sync4 = sync4 + enve4 .* sin1;
end

sync4 = sync4 / norm(sync4) * norm(sig);
%plot(sync4);
audiowrite('T4_Sync_f=100.wav', sync4, fs);
%sound(sync4,fs);

%N=4,LPF=400Hz
sync4 = [zeros(1, length(sig))]';
[LPF_b, LPF_a] = butter(4, 400 / (fs / 2));

for i = 1:6
    [l, h] = getFreq(6, i);
    [BP4_b, BP4_a] = butter(4, [l, h] / (fs / 2));
    y4 = abs(filter(BP4_b, BP4_a, sig));
    enve4 = filter(LPF_b, LPF_a, y4);
    n = 1:length(y4); dt = n / fs; f1 = (l + h) / 2;
    sin1 = sin(2 * pi * f1 * dt)';
    enve4 = enve4 / norm(enve4) * norm(sig);
    sync4 = sync4 + enve4 .* sin1;
end

sync4 = sync4 / norm(sync4) * norm(sig);
%plot(sync4);
audiowrite('T4_Sync_f=400.wav', sync4, fs);
%sound(sync4,fs);
