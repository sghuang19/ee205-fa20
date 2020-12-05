# Report of Signals and Systems Lab Project 1

The report for the first project of Signals and Systems lab session, written by following team members:

- HUANG Guanchao, SID 11912309 from SME
- GONG Xinrui, SID 11911233 from BME

---

## Introduction

---

## Background

---

## Methodology

---

## Code Implementation

To realize the function required in this project, we first wrote a function that is suitable for calculating the passband of each channel. The script is shown in the code block below.

```matlab
function [low, high] = passband(N, index)
    % passband - to get the pass band for each segment of frequency
    %
    % input -
    %   N - the number of channels
    %   index - the index of the frequency interval
    %
    % output -
    %   low - the lower cutoff frequency of the passband
    %   high - the higher cutoff frequency of the passband

    d200 = log10(200/165.4 + 1) / 0.06;
    d7000 = log10(7000/165.4 + 1) / 0.06;
    delta = d7000 - d200;
    dlow = d200 + (index - 1) / N * delta;
    dhigh = d200 + index * delta / N;
    low = 165.4 * (10^(0.06 * dlow) - 1);
    high = 165.4 * (10^(0.06 * dhigh) - 1);
end
```

Using the passband obtained in the above function, we may do filtering to seperate the original speech signal into channels, then process accordingly.

A 4-th order Butterworth filter is used to seperate the original speech signal into several channels. Then, envelope is extracted, and used to modulate sine wave signal, to produce a synthesized speech signal.

The main script for implementing `tone_vocoder` function is shown in the code block below.

```matlab
function sig = tone_vocoder(x, Fs, N, Fc)
    % tone_vocoder - the main function
    %
    % input -
    %   x - the speech signal to be processed, a row vector
    %   Fs - the sampling frequency of the speech signal
    %   N - the number of channels
    %   Fc - the cutoff frequency of LPF
    %
    % output -
    %   sig - the sum of the envelope extracted from the speech signal

    x = x';
    sig = zeros(1, length(x));
    [LPF_b, LPF_a] = butter(4, Fc / (Fs / 2));

    for index = 1:N
        [low, high] = passband(N, index);
        [BPF_b, BPF_a] = butter(4, [low high] / (Fs / 2));
        y = filter(BPF_b, BPF_a, x);
        y = abs(y);
        env = filter(LPF_b, LPF_a, y);

        n = 1:length(y);
        dt = n / Fs;
        f = (low + high) / 2;
        sine_wave = sin(2 * pi * f * dt);
        s = sine_wave .* env;
        sig = sig + s;
    end

    sig = sig / norm(sig) * norm(x);
end
```

---

## Data and Figures

---

## Discussion

---

## Appendix
