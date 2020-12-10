function out = channel(in, T)
    % channel - calculate the output signal of signal transfered throuth the channel. assuming the channel impulse response is
    % h(t) = 0.5\delta(t) + 0.4\delta(t - 1.5T) + 0.35\delta(t - 2.5T) + 0.3\delta(t - 3T)
    %
    % input -
    %   in - the input signal to be transfered through the channel
    %   T - sampling period
    % output -
    %   out - the output signal after transfered through the channel

    out = zeros(1, length(channel) + 3 * T);
    out = out + 0.5 * in;
    out = out + [zeros(1.5 * T, 1) in(1.5 * T:end)];
    out = out + [zeros(2.5 * T, 1) in(2.5 * T:end)];
    out = out + [zeros(3 * T, 1) in(3 * T:end)];
end
