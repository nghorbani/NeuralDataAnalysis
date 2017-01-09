function plotRasters(spikeTimes, stimOnsets, directions, stimDuration)
% Plot spike rasters.
%   plotRasters(spikeTimes, stimOnsets, directions, stimDuration) plots the
%   spike rasters for one single unitfor all 16 stimulus conditons. Inputs
%   are:
%       spikeTimes      vector of spike times           #spikes x 1
%       stimOnsets      vector of stimulus onset times (one per trial)
%                                                       #trials x 1
%       directions      vector of stimulus directions (one per trial)
%                                                       #trials x 1
%       stimDuration    duration of stimulus presentation in ms
%                                                       scalar

% plotting parameters
preStim = 500;
postStim = 500;

spikeHeight = 0.090909;
TPD = length(directions)/16; % #trials per direction

[~, sortedDirectsIdx ] = sort(directions);% firts sort out directions
sortedStimOnsets = stimOnsets(sortedDirectsIdx); %then get sorted onset times
ax = gca;
for directionIdx = 1:16
    %% Setting subplots
    if directionIdx < 9
        subplotIdx = 0; 
        xlabel('Time relative to stimulus onset - ms');
        ylabel('Direction of motion');
        ax121 = subplot(121);hold on;
        ylim(ax121,[0,8]);
        xlim(ax121,[-500,2500]);
        ax121.YTick = 0.5:7.5;        
        ax121.YTickLabel = arrayfun(@(p) sprintf('%.1f°', p),0:22.5:180,'UniformOutput',false);
        ax121.XTick = -500:1000:2500;
    else
        subplotIdx = 8;%so in next subplot also y begins from 0
        xlabel('Time relative to stimulus onset - ms');
        ax122 = subplot(122);hold on;
        ylim(ax122,[0,8]);
        xlim(ax122,[-500,2500]);
        ax122.YTick = 0.5:7.5;        
        ax122.YTickLabel = arrayfun(@(p) sprintf('%.1f°', p),180:22.5:360,'UniformOutput',false);
        ax122.XTick = -500:1000:2500;
    end
    %% actual plotting happens here
    Idx = 11*(directionIdx-1)+1;
    trialOnsets = sortedStimOnsets(Idx:Idx+10);
    for trialIdx = 1:length(trialOnsets)
        tiralOnset = trialOnsets(trialIdx);
        % get spiketimes within the stimulus window
        spikeTrain = spikeTimes( spikeTimes >= (tiralOnset- preStim) & spikeTimes <= (tiralOnset+stimDuration+postStim))';
        % normalize to -500 to 2500
        spikeTrain = normalizeTime(spikeTrain,(tiralOnset- preStim),(tiralOnset+stimDuration+postStim));
        spikeYStart = (directionIdx-subplotIdx-1)*TPD*spikeHeight+(trialIdx-1)*spikeHeight;
        line([spikeTrain;spikeTrain],[spikeYStart;spikeYStart+spikeHeight]*ones(size(spikeTrain)),'Color','k');
    end
    %plot dividing lines
    line([-500 2500],[spikeYStart+spikeHeight,spikeYStart+spikeHeight],'Color','k','LineWidth',0.01)
    if find([8,16]==directionIdx)
        % plotting above stimulus indicator line
        line([0 2000],[spikeYStart+spikeHeight,spikeYStart+spikeHeight],'Color','k','LineWidth',4)
    end
end