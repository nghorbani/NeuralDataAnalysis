function [s, t] = detectSpikes(x, Fs, spikeType)
%returns the indices and the times of spikes.
% Detect spikes.
%   [s, t] = detectSpikes(x, Fs) detects spikes in x, where Fs the sampling
%   rate (in Hz). The outputs s and t are column vectors of spike times in
%   samples and ms, respectively. By convention the time of the zeroth
%   sample is 0 ms.

if nargin<3;spikeType = 'extracellular';end

interpolation_factor = 10;

Ts = 1/Fs; % sampling period
discardWindow = 10; %samples to discard, no peaks closed than this

spikeSamples = [];
for ch = 1:size(x,2)
    signal = x(:,ch);
    
    sigma_n = median(abs(signal)/0.6754);% Automatic threshold
    if strcmp(spikeType,'extracellular');threshold = -5*sigma_n;else threshold = 5*sigma_n;end    

    [peaks, ~, ~] = find_crossings(signal, threshold, interpolation_factor, Fs,spikeType);
    spikeSamples = [spikeSamples,peaks']; % spike sample indices where the signal crosses the threshold from bottom up
end

[sSorted] = sort(spikeSamples);
s = [sSorted(1)];
for sIdx=1:length(sSorted)
    if sSorted(sIdx)>s(end)+discardWindow
        s = [s  sSorted(sIdx)];
    end
end
t = s*Ts;
