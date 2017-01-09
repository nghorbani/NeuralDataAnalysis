function [highestPower] = computeFFT(signal,Fs)
%% this function determines the highest frequency which has the 
% amplitue of at least some threshold percent of the maximum amplitude

T = 1/Fs;             % Sampling period
L = length(signal);   % Length of signal
t = (0:L-1)*T;        % Time vector

Y = fft(signal);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

threshold = 0.2;
f = Fs*(0:(L/2))/L;
highestPower = find(P1>max(P1)*threshold,1,'first');

%figure;plot(f(1:10000),P1(1:10000));
%title('Single-Sided Amplitude Spectrum of X(t)')
%xlabel('f (Hz)')
%ylabel('|Power(f)|')

end