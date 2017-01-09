function modulationRatio = linearityIndex(spikeTimes, stimOnsets, directions, stimDuration,binwidth,plotEnable)

% The modulation ratio is the amplitude of first harmonic R(F1) divided by 
% the mean spike rate R(F0) for an optimal achromatic drifting sinusoidal grating
% stimulus. High values of R(F1)/R(F0) indicate that the cells are modulated 
% by spatial pattern in the visual image. Low values of R(F1)/R(F0) signify 
% that such cells are excited, but their spike rate is not modulated up and down
% by the passage of the bars of a drifting grating.

if nargin<5, binwidth=10; end
if nargin<6, plotEnable=0; end

% plotting parameters
preStim = 500;
postStim = 500;

% w = rad/sec;
% (3 cyc/deg)^-1 * 3.4 cyc/sec = 1.13 deg/sec * (2*pi)/360 rad/sec =
w = 0.01978; %rad/s

TPD = length(directions)/16; % #trials per direction

[~, sortedDirectsIdx ] = sort(directions);% firts sort out directions
sortedStimOnsets = stimOnsets(sortedDirectsIdx); %then get sorted onset times
if plotEnable
    ax = gca;
end
%% find direction with maximum number of spikes
directNumSpikes = zeros(16,1);
for directionIdx = 1:16  
    Idx = 11*(directionIdx-1)+1;
    trialOnsets = sortedStimOnsets(Idx:Idx+10);
    for trialIdx = 1:length(trialOnsets)
        tiralOnset = trialOnsets(trialIdx);
        % get spiketimes within the stimulus window
        spikeTrain = spikeTimes( spikeTimes >= (tiralOnset- preStim) & spikeTimes <= (tiralOnset+stimDuration+postStim))';
        % normalize to -500 to 2500
        spikeTrain = normalizeTime(spikeTrain,(tiralOnset- preStim),(tiralOnset+stimDuration+postStim));
        directNumSpikes(directionIdx) = directNumSpikes(directionIdx) + length(spikeTrain);
    end
end
[~,directionIdx] = max(directNumSpikes); % direction with maximum number of spikes

angles = 0:22.5:359;
max_direct = angles(directionIdx); %maximum soike direction

%% plot PSTH over that directions spikes

% get stimulus onsets for trials with the same angle
trials = stimOnsets(directions == max_direct);
% create bins for histogram
bins = 0:binwidth:(stimDuration+preStim+postStim-1);
spikecount = zeros(length(bins), 1);

for t = 1:length(trials)
    start_time = trials(t) - preStim;
    end_time = trials(t) + stimDuration + postStim;
    % filter spikes for this specific trial
    preSelect = spikeTimes >= start_time;
    spikes = spikeTimes(preSelect);
    postSelect = spikes <= end_time;
    spikes = spikes(postSelect);
    % normalize spikes to stimulus onset
    spikes = arrayfun(@(t) t-start_time, spikes);
    for s = 1:length(spikes)
        index = floor(spikes(s)/binwidth)+1;
        spikecount(index) = spikecount(index) + 1;
    end
end    
spikecount = spikecount ./ (binwidth * 0.001);
if plotEnable
    axis([0 3000 0 100]);
    bar(bins, spikecount, 'histc');hold on;
end
Fs = 1/(binwidth*10^-3);
L = length(spikecount);   % Length of signal

f = Fs*(0:L/2)/L;
S = fft(spikecount);

spec2 = abs(S/L);%2 sided spectrum
spec = spec2(1:L/2+1);%1 sided spectrum
spec(2:end-1) = 2*spec(2:end-1);

F1 = interp1(f,spec,3.4);
F0 = mean(spikecount);

fIdx = find(f>=3.4,1);
singlefreqf = zeros(size(S));singlefreqf(fIdx) = S(fIdx);
singlefreqt = ifft(singlefreqf);    
modulationRatio = F1/F0;

if plotEnable
    t = binwidth:binwidth:3000; plot(t,real(10*singlefreqt),'r');
    xlim([-0,2500]);
    ax = gca;
    ax.XTick = -500:500:2500;
end 

end