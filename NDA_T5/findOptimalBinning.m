function opt_width = findOptimalBinning(spikeTimes, stimOnsets, directions, stimDuration,plotEnable)
if nargin<5;plotEnable=0;end;

%% Find condition with maximal spike count
mostSpikes = [];

preStim = 500;
postStim = 500;

for angle = 0:22.5:359
    % get stimulus onsets for trials with the same angle
    trials = stimOnsets(directions == angle);
    acc_spikes = [];
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

        acc_spikes = [acc_spikes; spikes];
    end
    
    if length(acc_spikes) > length(mostSpikes)
        mostSpikes = acc_spikes;
    end    
    
end

Y = cost(mostSpikes, 1:250, stimDuration, preStim, postStim);
[opt_val, opt_width] = min(Y);
if plotEnable
    subplot(221);hold on; title('Cost function');
    plot(Y,'b');plot(opt_width,opt_val,'r*');
    annotation('textbox', [.2 .5 .3 .3],'String',sprintf('optimal \\Delta: %d',opt_width),'FitBoxToText','on');

    xlabel('\Delta');
    ylabel('C_n(\Delta)');
end

[bins, counts] = binSpikes(mostSpikes, opt_width, stimDuration, preStim, postStim);
if plotEnable
    subplot(222);hold on; title('PSTH with optimal \Delta');
    bar(bins, counts, 'histc');
    xlabel('Time relative to stimulus onset - ms');
    ylabel('spikes/sec')
    xlim([-500 2500]);
end
[bins, counts] = binSpikes(mostSpikes, ceil(opt_width/10), stimDuration, preStim, postStim);
if plotEnable
    subplot(223);hold on; title('PSTH with sub-optimal \Delta');
    bar(bins, counts, 'histc');
    xlabel('Time relative to stimulus onset - ms');
    ylabel('spikes/sec')
    xlim([-500 2500]);
end

[bins, counts] = binSpikes(mostSpikes, opt_width*10, stimDuration, preStim, postStim);
if plotEnable
    subplot(224);hold on; title('PSTH with supra-optimal \Delta');
    bar(bins, counts, 'histc');
    xlabel('Time relative to stimulus onset - ms');
    ylabel('spikes/sec')
    xlim([-500 2500]);
end
end

function Y = cost(spikes, binwidth, duration, pre, post)
Y = zeros(length(binwidth), 1);

for i=1:length(binwidth)
    [bins, spikecount] = binSpikes(spikes, binwidth(i), duration, pre, post);
    n = length(bins);
    
    m = sum(spikecount)/n;
    sigma = sum((spikecount - m*ones(n, 1)).^2)/n;
    Y(i) = (2*m - sigma)/binwidth(i)^2;
end
end

function [bins, X] = binSpikes(spikes, binwidth, duration, pre, post)
    bins = -pre:binwidth:duration + post-1;
    X = zeros(length(bins), 1);
    for s=1:length(spikes)
        index = floor(spikes(s)/binwidth)+1;
        X(index) = X(index) + 1;
    end
    
    % normalization to spikes/sec
    %X = X ./ (binwidth* 0.001);    
end