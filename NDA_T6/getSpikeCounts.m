function counts = getSpikeCounts(spikeTimes, stimOnsets, directions, stimDuration)
% Get firing rate matrix for stimulus presentations.
%   counts = getSpikeCounts(spikeTimes, stimOnsets, directions, stimDuration)
%   Inputs:
%       spikeTimes      vector of spike times           #spikes x 1
%       stimOnsets      vector of stimulus onset times (one per trial)
%                                                       #trials x 1
%       directions      vector of stimulus directions (one per trial)
%                                                       #trials x 1
%       stimDuration    duration of stimulus presentation in ms
%                                                       scalar
%   Output: 
%   counts      matrix of spike counts during stimulus presentation. The
%               matrix has dimensions #trials/direction x #directions

num_trials = length(stimOnsets);
num_directions = length(unique(directions));
counts = zeros(num_trials/num_directions, num_directions);

% counter for trials per direction
counter = ones(num_directions, 1);

for trialIdx=1:num_trials
    % get index of current direction
    dirIdx = round(directions(trialIdx)/22.5) + 1;
    
    stimStart = stimOnsets(trialIdx);
    stimEnd = stimStart + stimDuration;    
    timeMask = stimStart <= spikeTimes & spikeTimes <= stimEnd;

    % update spikecount for current trial of this direction
    counts(counter(dirIdx), dirIdx) = length(spikeTimes(timeMask));
    
    % update trial counter
    counter(dirIdx) = counter(dirIdx) + 1;
end