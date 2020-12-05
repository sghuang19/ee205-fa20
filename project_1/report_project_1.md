# Report of Signals and Systems Lab Project 1

The report for the first project of Signals and Systems lab session, written by following team members:

- HUANG Guanchao, SID 11912309 from SME
- GONG Xinrui, SID 11911233 from BME

The complete resources, including report in `.pdf` and `.md` format, as well as all MATLAB scripts, can be retrieved at [our GitHub repo](https://github.com/SamuelHuang2019/ss-project).

---

## Introduction

---

## Background

### Feasibility

By Fourier’s transformation, signals can be decomposed into a sum of sinusoids of different frequencies. This is especially relevant with human hearing, since the inner ear performs a form of mechanical Fourier transform by mapping frequencies along the length of the cochlear partition. Our work is based on the idea proposed by Hilbert[^Hilbert], a signal can be factored into the product of a slowly varying envelope and a rapidly varying fine time structure.

[^Hilbert]: Hilbert, D. *Grundzüge einer allgemeinen Theorie der linearen Integralgleichungen* (Teubner, Leipzig, 1912).

According to the research done by Smith, Delgutte and Oxenham[^Smith],

>"Envelope is most important for speech reception, and the fine structure is most important for pitch perception and sound localization. When the two features are in conflict, the sound of speech is heard at a location determined by the fine structure, but the words are identified according to the envelope."
>
>![Auditory Chimaera Synthesis](https://raw.githubusercontent.com/SamuelHuang2019/ss-project/master/project_1/figures/auditory_chimaera_synthesis.png)
>
>The figure exhibits how auditory chimaera synthesis is done clearly.

This indicates that we should focus on the envelope extracted to improve the distinguishability of the synthesized speech signal, and focus on the fine structure for better pitch and tone performance.

<!-- 来自“确定有用的参考论文” -->

[^Smith]: Smith, Z. M., Delgutte, B., & Oxenham, A. J. (2002). Chimaeric sounds reveal dichotomies in auditory perception. *Nature*, 416(6876), 87–90.

The research done by Shannon et al.[^Shannon] provides a conciser instruction for our project.

>"The identification of consonants, vowels, and words in simple sentences improved markedly as the number of bands increased"

The feasibility of recognizing speech signal with "greatly reduced spectral information" is well proved.

<!-- 来自“参考论文” -->

[^Shannon]: Vongphoe, M., & Zeng, F. G. (2005). Speaker recognition with temporal cues in acoustic and electric hearing. *The Journal of the Acoustical Society of America*, 118(2), 1055–1061.

### Practice

A research by MacCallum et al.[^MacCallum] provides us with the instructions for setting the cutoff frequency of the low-pass filter.

>"To ensure accuracy in acoustic voice analysis, setting the cutoff frequency of a low-pass filter at least one octave above the fundamental frequency (minimum of $300\mathrm{Hz}$) is recommended."

[^MacCallum]: Julia K. MacCallum, Aleksandra E. Olszewski, Yu Zhang, Jack J. Jiang,
Effects of Low-Pass Filtering on Acoustic Analysis of Voice, *Journal of Voice*, Volume 25, Issue 1, 2011, Pages 15-20.

The experimental results presented by Drullman, Festen and Plomp[^Drullman] took one step further in the discussion of the relationship between the sentence intelligibility number of bands and cutoff frequency chosen.

<!-- 来自“随意的没看过的高引用参考” -->

[^Drullman]: Drullman, R., Festen, J. M., & Plomp, R. (1994). Effect of temporal envelope smearing on speech reception. *The Journal of the Acoustical Society of America*, 95(2), 1053–1064.

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

![example](https://raw.githubusercontent.com/SamuelHuang2019/ss-project/master/project_1/figures/task_1.png)

---

## Discussion

---

## Appendix
