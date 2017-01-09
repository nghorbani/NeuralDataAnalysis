function w = extractWaveforms(x, s)
% Extract spike waveforms.
%   w = extractWaveforms(x, s) extracts the waveforms at times s (given in
%   samples) from the filtered signal x using a fixed window around the
%   times of the spikes. The return value w is a 3d array of size
%   length(window) x #spikes x #channels.

Fs = 30000;
Ts = 1/Fs; % sampling period

prePeakSamples = .4*1e-3*Fs;
postPeakSamples = .6*1e-3*Fs;
spikeWindow = prePeakSamples+postPeakSamples;

for ch = 1:4
    signal = x(:,ch);
    for i = 1:length(s)
        spike_loc = round(s(i));
        if spike_loc ~= 0
            spikeTrace = signal(spike_loc - prePeakSamples: spike_loc + postPeakSamples-1);
            spikeTraces(:,i,ch) = spikeTrace;
        end
    end
end
w = spikeTraces;
