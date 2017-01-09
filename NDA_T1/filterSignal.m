function y = filterSignal(x, Fs)
% Filter raw signal
%   y = filterSignal(x, Fs) filters the signal x. Each column in x is one
%   recording channel. Fs is the sampling frequency. The filter delay is
%   compensated in the output y.

% %bandpass filter desing
% fast
order = 12;
fcutlow = 500; % Hz to get rid of LFPs
fcuthigh = 5000; % Hz to avoid high Frequency noise

bandpass_filter = designfilt('bandpassiir','FilterOrder',order, ...
    'HalfPowerFrequency1',fcutlow,'HalfPowerFrequency2',fcuthigh, ...
    'SampleRate',Fs);

y = zeros(size(x));
for ch = 1:size(x,2)
    y(:,ch) = filtfilt(bandpass_filter,x(:,ch));
end
% 
% %slow
% %% parameters
% Fstop1 = 450;    % First Stopband Frequency
% Fpass1 = 500;    % First Passband Frequency
% Fpass2 = 5000;   % Second Passband Frequency
% Fstop2 = 5050;   % Second Stopband Frequency
% Astop1 = 60;   % First Stopband Attenuation (dB)
% Apass  = 0.1;  % Passband Ripple (dB)
% Astop2 = 60;   % Second Stopband Attenuation (dB)
% 
% filterBp = fdesign.bandpass('fst1,fp1,fp2,fst2,ast1,ap,ast2', Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, Astop2, Fs);
% filterObj = design(filterBp, 'equiripple', 'MinOrder', 'any');
% 
% y = zeros(size(x));
% for ch = 1:size(x,2)
%     y(:,ch) = filtfilt(filterObj.Numerator, 1, x(:,ch));
% end

end