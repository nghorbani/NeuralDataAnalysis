function w = extractWaveforms_aligned(x, s, Fs, spikeType)
% Extract spike waveforms.
%   w = extractWaveforms(x, s) extracts the waveforms at times s (given in
%   samples) from the filtered signal x using a fixed window around the
%   times of the spikes. The return value w is a 3d array of size
%   length(window) x #spikes x #channels.
if nargin<3;Fs = 30000;end
if nargin<4;spikeType = 'extracellular';end

Ts = 1/Fs; % sampling period
interpolation_factor = 10;

prePeakSamples = .4*1e-3*Fs;
postPeakSamples = .6*1e-3*Fs;
extraWindowSamples = .5*1e-3*Fs;
spikeWindow = prePeakSamples+postPeakSamples;

max_nspikes = length(s);

% increasing the sample times by the amount of interpolation
singleSpikeTraceTime =  Ts/interpolation_factor:Ts/interpolation_factor:spikeWindow*Ts;
spikeTraces = zeros(ceil(length(singleSpikeTraceTime)/interpolation_factor),max_nspikes,size(x,2));

preSmoothPeakSamples = prePeakSamples * interpolation_factor;
postSmoothPeakSamples = postPeakSamples * interpolation_factor;

for ch = 1:size(x,2)
    signal = x(:,ch);
    %since whole signal interpolation is not efficient will do an inplace
    %windowed interpolation around the peak
    for i = 1:length(s)
        try
            %1 - get location of the peak of the spike in undersampled data and
            % the spike with bigger window
            spike_loc = round(s(i));
            spikeTrace = signal(spike_loc - (prePeakSamples+extraWindowSamples): spike_loc + postPeakSamples+extraWindowSamples-1);
            %2 - interpolate this bigger window and get relative window size 
            smoothedSpikeTrace = smooth(spikeTrace,interpolation_factor, Fs);
            minSearchWindow = smoothedSpikeTrace(preSmoothPeakSamples:end-postSmoothPeakSamples);
            if strcmp(spikeType,'extracellular'); [~,spike_loc] = min(minSearchWindow); else [~,spike_loc] = max(minSearchWindow);end
            spike_loc = spike_loc + preSmoothPeakSamples;
            allignedSpikeTrace = smoothedSpikeTrace(spike_loc - preSmoothPeakSamples: spike_loc + postSmoothPeakSamples-1);
            %spikeTraces(:,i,ch) = align_spikeTrace(spikeTrace,prePeakSamples,postPeakSamples,Fs);
            %spikeTraces(:,i,ch) = allignedSpikeTrace(1:interpolation_factor:end); %downsample
            spikeTraces(:,i,ch) = decimate(allignedSpikeTrace,interpolation_factor,'FIR'); % downsample

        catch
            continue
        end
    end
end
w = spikeTraces;