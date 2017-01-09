function plotPsth(spikeTimes, stimOnsets, directions, stimDuration)
% Plot peri-stimulus time histograms (PSTH).
%   plotPsth(spikeTimes, stimOnsets, directions, stimDuration) plots the
%   PSTHs for one single unit for all 16 stimulus conditons. Inputs are:
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
binwidth = 10;

[ha, pos] = tight_subplot(8, 2, [0 .1],[.1 .1],[.1 .1]);
odd = true;
ct = 0;
for angle = 0:22.5:359
    if odd
        hist_ind = 2*ct+1;
        ct = ct + 1;
        if ct == 5;ylabel('Direction of motion');end; % patch!
        if ct == 8
            ct = 1;
            odd = false;
            xlabel('Time relative to stimulus onset - ms');
        end
    else
        hist_ind = 2*ct;
        ct = ct + 1;
    end
    % get stimulus onsets for trials with the same angle
    trials = stimOnsets(directions == angle);
    
    % create bins for histogram
    bins = -preStim:binwidth:(stimDuration+postStim-1);
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
        spikes = arrayfun(@(time) time-start_time, spikes);
        
        for s = 1:length(spikes)
            index = floor(spikes(s) / binwidth)+1;
            spikecount(index) = spikecount(index) + 1;
        end
    end
    
    % normalize spikecounts to spikes/sec
    spikecount = spikecount ./ (binwidth * 0.001);% since spike times are in ms
    
    hist_plot = ha(hist_ind);
    
    axes(hist_plot);
    bar(bins, spikecount, 'histc');
%    title(sprintf('%.1f°', angle));
    set(hist_plot,'YLim',[0 500]);
    set(hist_plot,'XLim',[-500 2500]);

    hist_plot.YTick = 250;        
    hist_plot.YTickLabel = sprintf('%.1f°', angle);
	hist_plot.XTick = -500:500:2500;
    xlabel('Time relative to stimulus onset - ms');

end
xlabel('Time relative to stimulus onset - ms');
set(ha(1:14),'XTickLabel','');