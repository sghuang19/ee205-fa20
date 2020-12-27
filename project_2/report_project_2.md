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

In this project, we implemented the whole process of OFDM in signal transmission with MATLAB, including

- the generation of signal
- loading signal in frequency domain
- adding cyclic prefix
- transmission in the channel
- remove the cyclic prefix in receiver-side
- recover the original signal in time domain

## Introduction

In our practice, the baseband, or carrier signal we choses is a sine wave and a cosine wave signal. The sine wave is for the real part, and the cosine wave is for the imaginary part.

```matlab
% time-step
dt = 1e-9;
% carrier signal frequency
wc = 100e6;

t = (1:length(x_sq)) * dt;
sin1 = sin(2 * pi * wc * t);
cos1 = cos(2 * pi * wc * t);
```

The signals to be transferred are firstly loaded in the frequency domain with `ifft()` function.

```matlab
X = xr + 1i * xi;
x = ifft(X);
```

Then, a cyclic prefix is added to the signal loaded in the frequency domain to obtain OFDM features.

```matlab
x_cp = [x(N - lcp + 1:N), x];
```

After that, digital-analog-convert is done. Also, reshape the sampled impulse series into zero-order held square wave series.

```matlab
x_cp_ct = upsample(x_cp, 1000);
x_sq = reshape(repmat(x_cp, 1000, 1), 1, []);
```

In this process, the signal is upsampled by inserting $1000 - 1 = 999$ zeros between the samples of the DT signal.

Next, do amplitude modulation.

```matlab
t = (1:length(x_sq)) * dt;
sin1 = sin(2 * pi * wc * t);
cos1 = cos(2 * pi * wc * t);
x_am = cos1 .* real(x_sq) + sin1 .* imag(x_sq);
```

The transmission channel is defined as

```matlab
A = 1;
B = [0.5 zeros(1, 1.5e3 - 1) 0.4 zeros(1, 1e3 - 1) 0.35 zeros(1, 0.5e3 - 1) 0.3];
```

The signal is passed through which.

```matlab
yh = filter(B, A, x_am);
```

---

## Receiver Design and Analysis

### Receiver RF Front-End & ADC (Block 4)

The process diagram of the design of receiver RF front-end with ADC(Block 4) is shown below.

```mermaid
graph LR
    1["CT signal<br/>after actual<br/>wireless<br/>channel h(t)"]
    cos[Multiply with<br/>2cosωt]
    sin[Multiply with<br/>2sinωt]

    1 ==> cos
    1 ==> sin
    cos ==> LPFup((LPF))
    sin ==> LPFlow((LPF))

    xr{{"[xr(t) * h(t)]"}}
    xi{{"[xi(t) * h(t)]"}}

    LPFup ==> xr ==> ADC
    LPFlow ==> xi ==> ADC

    ADC["Integrator<br/>(ADC)"] ==> y{{"ycp[n]"}}
```

Firstly, we use coherent demodulation, to divide the real part and image part of the signal. Because we modulate the signal in block 3 by multiplying sine and cosine wave, we can demodulate it by doing this inversely. After multiplying with $2\sin\omega_ct$ and $2\cos\omega_ct$ separately, the analytical result is shown as below.

$$
\begin{cases}
2\cos\omega_ct[x_r(t)\cos\omega_ct + x_i(t)\sin\omega_ct]=
x_r(t) + x_r(t)\cos{2\omega}_ct + x_i(t)\sin{2\omega}_ct \\
2\sin\omega_ct[x_r(t)cos\omega_ct + x_i(t)\sin\omega_ct] =
x_i(t) - x_i(t)\cos{2\omega}_ct + x_r(t)\sin{2\omega}_ct
\end{cases}
$$

We use LPF to get the real and imaginary part of $x(t)$ and add them together as $x_r(t) + x_i(t)i$ to get $y(t)$, which still contains the CP. Then we use integrator as ADC part to accumulate the received power and generate DT signal $y_\text{CP}[n]$.

$$
\begin{aligned}
y_\text{int}(t) & =
\frac{1}{T} \int_{t - T}^{t} y_{\text{dem}(\tau)}\mathop{d\tau} \\
y[n] & =
y_\text{int}(nT) =
\frac{1}{T} \int_{(n-1)T}^{nT} y_{\text{dem}(\tau)}\mathop{d\tau} =
\frac{1}{T} \int_{(n-1)T}^{nT}{x_c(\tau) h(\tau)}\mathop{d\tau}
\end{aligned}
$$

Finally, we need to remove the CP and get the result $y[n]$, which corresponds to the convolution of $x[n]$ and $h[n]$.

### Determining the Length of CP  

According to our research, the length of cp needs to be bigger than the maximum delay expansion of the channel which should be able to cancel Inter-Symbol Interference (ISI) and ICI. Since

$$
h(t) =
0.5\delta(t) +
0.4\delta(t - 1.5T) +
0.35\delta(t - 2.5T) +
0.3\delta(t - 3T),
$$

the maximum delay is $3T = 3\mu\mathrm{s}$, we take CP equals $4\mu\mathrm{s}$. Besides, the length of CP should guarantee that the result of cyclic convolution is concluded in linear convolution, which is verified in the simulation taking length of CP equals $4$.

---

## Simulations

We first create a signal as follows:

```matlab
% set real and imaginary part of signal
xr = sqrt(2) * round(rand(1, N)) - sqrt(2) / 2; 
xi = sqrt(2) * round(rand(1, N)) - sqrt(2) / 2;
```

The plot for our signal is as below.

![InputSignal](figures/figure1.png)

Then we use `ifft()` to produce the signal in time domain.  

![OFDM-Signal](figures/figure2.png)

After that we add `cp` with length of 4 to this signal.

![OFDM-Signal+cp](figures/figure3.png)

We then produce the impulse result of OFDM signal and then use square signal to shape it.

![OFDM-Signal+cp](figures/figure4.png)

Then we add carrier signal to the OFDM signal.

![OFDM-Signal+cp](figures/figure5.png)

After that, we simulate the process of real wireless channel.

![OFDM-Signal+cp](figures/figure6.png)

Then the signal experience a process of demodulation and pass through a LPF.

![OFDM-Signal+cp](figures/figure7.png)

Sampling:

![OFDM-Signal+cp](figures/figure8.png)

Then we remove cp.

![OFDM-Signal+cp](figures/figure9.png)

Then we can recover X since `X_recover_N=Y_recover_N./H;`

![OFDM-Signal+cp](figures/figure10.png)

---

## Discussions

---

### Applications

OFDM is now used in most new and emerging broadband wired and wireless communication systems because it is an effective solution to intersymbol interference caused by a dispersive channel. And now it will approximately be used in some other fields.

In spite of the widespread use of OFDM in wireless communication, recently OFDM has also applied in optical communication[^Armstrong]. OFDM used in optical communication has some difference with the traditional one, and the following table can clearly show the distinctions.

[^Armstrong]:J. Armstrong, "OFDM for Optical Communications," in Journal of Lightwave Technology, vol. 27, no. 3, pp. 189-204, Feb.1, 2009, doi: 10.1109/JLT.2008.2010061.

![OP-OFDM](figures/OP_OFDM.png)

To let OFDM useful in optical communication systems, in the optical domain, optical receivers use square-law detectors for producing a $H_k$ close to be a constant or slowly varying. Other improvement like using Intensity Modulation, MIMO-OFDM are also widely use in optical communication systems.

In addition, based on OFDM, some waveforms having the same principles are created for 5G development[^Moradi]. WAveforms like Generalized frequency division multiplexing (GFDM) is introduced in 2009 by Fettweis et al. is an "improvement to OFDM in which filtering is imposed on each subcarrier band to minimize the overlapping among subcarriers, thus facilitate multiuser application without worrying about accurate synchronization of the users.",it also solves the downside of adjacent subcarriers suffer from some level of interference from adding cp to the signals.

[^Moradi]:B. Farhang-Boroujeny and H. Moradi, "OFDM Inspired Waveforms for 5G," in IEEE Communications Surveys & Tutorials, vol. 18, no. 4, pp. 2474-2492, Fourthquarter 2016, doi: 10.1109/COMST.2016.2565566.

![GFDM](figures/GFDM.png)

Moreover, O-OFDM, a kind of improvement OFDM waveforms are a promising modulation[^Elgala] for Visible light communications (VLC) technology, which permits the exploitation of light-emitting diode (LED) luminaries for simultaneous illumination and broadband wireless communication.

[^Elgala]:. Hany Elgala and Thomas D. C. Little, "Reverse polarity optical-OFDM (RPO-OFDM): dimming compatible OFDM for gigabit VLC links," Opt. Express 21, 24288-24299 (2013)

---

### Advantages

First of all, the biggest advantages of OFDM is to resist frequency selective fading or narrowband interference. Since OFDM is a multi-carrier system, only a small part of subcarrier and the relating information will have the problems of being affected when the frequency selective fading occurs. However, if we use traditional single carrier system, the effects will be "amplified" and cause the whole system to be influence and a large amount of of information will be lost or disturbed. Therefore, on a whole, using OFDM is much better for protecting the information and signals transmitting in these waveforms.

Secondly, being a multi-carrier, OFDM can carrying much information and these satisfy the contemporary society needs for faster and more efficient information transmission.

Thirdly, OFDM can robust against intersymbol interference(ISI). ISI is a form of distortion of a signal in which one symbol interferes with subsequent symbols. This is an unwanted phenomenon as the previous symbols have similar effect as noise, thus making the communication less reliable. The spreading of the pulse beyond its allotted time interval causes it to interfere with neighboring pulses.

In an OFDM system, the entire channel is divided into many narrow subchannels, which are utilized in parallel transmission, thereby increasing the symbol duration and reducing the ISI. Therefore, OFDM is an effective technique for combating multipath fading and for high-bit-rate transmission over mobile wireless channels.

Besides, because of the longer duration of symbols, the OFDM system can alleviate the effect of impulse noise.
  >When an OFDM system is designed so that there is neither interchannel interference (ICI) nor ISI, the computationally efficient fast Fourier transform (FFT) can be applied to decouple subchannels and the channel equalization is achieved simply by a complex scalar for each independent subchannel.[^Sun]
  >
  [^Sun]:Yi Sun and Lang Tong, "Bandwidth efficient wireless OFDM," Conference Record of Thirty-Second Asilomar Conference on Signals, Systems and Computers (Cat. No.98CH36284), Pacific Grove, CA, 1998, pp. 78-82 vol.1, doi: 10.1109/ACSSC.1998.750831.

In addition, OFDM technology can easily adapt to severe channel conditions without complex time-domain equalization. This is because OFDM can dynamically adapt to it and ensure continuous and successful communication, no matter the changes in the ability of data transmission.

And comparing to traditional FDM, OFDM doesn't  required tuned sub-channel receiver filters.

---

### Disadvantages

1. The OFDM signal has a noise like amplitude with a very large dynamic range; hence it requires RF power
amplifiers with a high peak to average power ratio.

2. It is more sensitive to carrier frequency offset and drift than single carrier systems are due to leakage of the DFT.

3. It is sensitive to Doppler shift.

4. It requires linear transmitter circuitry, which suffers from poor power efficiency.

5. It suffers loss of efficiency caused by cyclic prefix.

---

## Appendix
