function showFFT(signal,Fs)

%% from https://dadorran.wordpress.com/2014/02/17/plot_freq_spectrum/
N = length(signal);
fnyquist = Fs/2; %Nyquist frequency
 
%% Single-sided magnitude spectrum with frequency axis in Hertz
% Each bin frequency is separated by fs/N Hertz.
X_mags = abs(fft(signal));
bin_vals = [0 : N-1];
fax_Hz = bin_vals*Fs/N;
N_2 = ceil(N/2);
plot(fax_Hz(1:N_2), X_mags(1:N_2))
xlabel('Frequency (Hz)')
ylabel('Magnitude');
title('Single-sided Magnitude spectrum (Hertz)');
axis tight
%  
% %% Single-sided power spectrum in decibels and Hertz
% X_mags = abs(fft(signal));
% bin_vals = [0 : N-1];
% fax_Hz = bin_vals*fs/N;
% N_2 = ceil(N/2);
% figure(109),plot(fax_Hz(1:N_2), 20*log10(X_mags(1:N_2)))
% xlabel('Frequency (Hz)')
% ylabel('Power (dB)');
% title('Single-sided Power spectrum (Hertz)');
% axis tight
 