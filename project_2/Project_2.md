# Report of Signals and Systems Lab Project 2

The report for the first project of Signals and Systems lab session, written by following team members:

- HUANG Guanchao, SID 11912309 from SME
- GONG Xinrui, SID 11911233 from BME
- XUE Feng, SID 11913020 from MEE
- HE Xinyi, SID 11911234 from BME

---

## Abstract

Orthogonal frequency-division multiplexing(OFDM), a type of digital transmission and a method of encoding digital data on multiple carrier frequencies. In this project, we focus on the 


---

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



Then we use `ifft()` to produce the signal in time domain and add `cp` with length of 4 to this signal. 

---

## Discussions

---

---

## Appenndix

