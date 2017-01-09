function plotWaveforms(w, assignments, varargin)
% Plot waveforms for each cluster.
%   plotWaveforms(w, assignment) plots for all four channels of each
%   cluster 100 sample waveforms, overlaid by the average waveform. All
%   panels are drawn on the same scale to facilitate comparison.
Fs = 20000;
Ts = 1/Fs; % sampling period
segmentSize = size(w,1);%samples
time = Ts:Ts:segmentSize*Ts; % for plotting purposes, hrizontal plane time
K = max(assignments);
plotColors = distinguishable_colors(K);
for kIdx = 1:K %for each cluster
    spikeToShow = find(assignments == kIdx);%get index of spikes to show
    spikeToShow = spikeToShow(randperm(length(spikeToShow),100)); % randomly select among them
    for ch=1:4%for each channel
        spikeWaveforms = w(:,spikeToShow,ch); %get wave forms
        subplot(4,K,kIdx + K*(ch-1));%get subplot id
        hold on;
        for spikeIdx = 1:100
            plot(time*1000,spikeWaveforms(:,spikeIdx),'color',[0.5 0.5 0.5]);
            xlim([0 segmentSize*Ts*1000]);ylim([-100,100]);
            axis off

        end
        plot(time*1000,mean(spikeWaveforms,2),'color',plotColors(kIdx,:),'LineWidth',3);
        %if kIdx == 1;ylabel('\muV');end;
        %title(sprintf('Cluster %d',kIdx));
    end
    %xlabel('ms')
    axis off
end
%suptitle('Fig. 1 Visual inspection of waveforms');
    
end