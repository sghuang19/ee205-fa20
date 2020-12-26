# Report of Signals and Systems Lab Project 2

The report for the first project of Signals and Systems lab session, written by following team members:

- HUANG Guanchao, SID 11912309 from SME
- GONG Xinrui, SID 11911233 from BME
- XUE Feng, SID 11913020 from MEE
- HE Xinyi, SID 11911234 from BME

The complete resources, including report in `.pdf` and `.md` format, as well as all MATLAB scripts, can be retrieved at [our GitHub repo](https://github.com/SamuelHuang2019/ss-project).

[toc]

---

## Abstract

In this project, we implemented the whole process of OFDM in signal transmission with MATLAB.

## Introduction

---

## Receiver Design and Analysis

---

## Simulations

We first create a signal as follows:

```matlab
% set real and imaginary part of signal
xr = sqrt(2) * round(rand(1, N)) - sqrt(2) / 2; 
xi = sqrt(2) * round(rand(1, N)) - sqrt(2) / 2;
```

The plot for our signal is as below.

![InputSignal](figures/OriginalSignal.png)

Then we use `ifft()` to produce the signal in time domain.  

![OFDM-Signal](figures/OFDM_Signal.png)

After that we add `cp` with length of 4 to this signal.

![OFDM-Signal+cp](figures/OFDM_Signal+cp.png)

To make our signal discrete, we first produce the impulse result of OFDM signal and then use square signal to simulate it.

![OFDM-Signal+cp](figures/CT_impulse_square.png)

Then we add carrier signal to the OFDM signal.

![OFDM-Signal+cp](figures/CT_AM_Signal.png)

After that, we simulate the process of real wireless channel.

![OFDM-Signal+cp](figures/CT_transmit.png)

Then the signal experience a process of demodulation and pass through a LPF.

![OFDM-Signal+cp](figures/Demodulation.png)

Sampling:

![OFDM-Signal+cp](figures/sampling.png)

Then we remove cp.

![OFDM-Signal+cp](figures/remove_cp.png)

Then we can recover X since `X_recover_N=Y_recover_N./H;`

![OFDM-Signal+cp](figures/recover.png)

---

## Discussions

---

## Appendix
