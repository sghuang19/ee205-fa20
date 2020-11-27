function [sync] = vocoder(LPF,N,sig,fs)
%N:the number we divide the frequency
%LPF:cutoff frequency when extract envelope
%sig:the signal to be operated
%fs:the sampling rate
sync=[zeros(1,length(sig))]';
[LPF_b,LPF_a]=butter(4,LPF/(fs/2));
for i=1:N
    [l,h]=getFreq(N,i);
    [BP_b,BP_a]=butter(4,[l,h]/(fs/2));
    y=abs(filter(BP_b,BP_a,sig));
    enve=filter(LPF_b,LPF_a,y);
    n=1:length(y);dt=n/fs;f1=(l+h)/2;
    sin1=sin(2*pi*f1*dt)';
    enve=enve/norm(enve)*norm(sig);
    sync=sync+enve.*sin1;
end
sync=sync/norm(sync)*norm(sig);
end

