function [low, high] = getFreq(N, i)
    d200 = log10(200/165.4 + 1) / 0.06; d7000 = log10(7000/165.4 + 1) / 0.06;
    delta = d7000 - d200;
    dlow = d200 + (i - 1) / N * delta; dhigh = d200 + i * delta / N;
    low = 165.4 * (10^(0.06 * dlow) - 1); high = 165.4 * (10^(0.06 * dhigh) - 1);
end
