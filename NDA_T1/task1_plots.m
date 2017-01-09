function task1_plots(x,y,s,t,w,b,Fs,spikeType)
%%
set(0,'DefaultFigureWindowStyle','docked');
if nargin<3;spike_type = 'extracellular';end
Ts = 1/Fs; % sampling period
% since length(x)/samplingRate = 64 sec of recording
% segmentSize determines length (sec) of this segement
segmentSize = 10; % seconds [here 100ms]
time = Ts:Ts:length(x)*Ts; % for plotting purposes, hrizontal plane time
timeSegment = time(1:segmentSize*Fs);
lengthSegment = 1:segmentSize*Fs;

% somehow these variables should have been made global!
prePeakSamples = .4*1e-3*Fs;
postPeakSamples = .6*1e-3*Fs;
spikeWindow = prePeakSamples+postPeakSamples;

NChannels = size(x,2);

%% figure 1
% plotting raw Signal and filtered one
figure(101);
for ch = 1:NChannels
    subplot(NChannels,2,2*ch-1);plot(timeSegment*1000,x(lengthSegment,ch));
    ylabel('amp. [{\mu}V]')
    subplot(NChannels,2,2*ch);plot(timeSegment*1000,y(lengthSegment,ch));
end
subplot(NChannels,2,2*ch-1);xlabel('time [ms]');
subplot(NChannels,2,2*ch);xlabel('time [ms]');
suptitle ('Task 1 - Figure 1')

%% figure 2
% plotting peak points for detected spikes
% points might not be at the exact peaks because they are determined for
% up_sampled data
figure(102);
for ch = 1:NChannels
    signal = y(lengthSegment,ch);

    sigma_n = median(abs(y(:,ch))/0.6745);
    if strcmp(spikeType,'extracellular');threshold = -5*sigma_n;else threshold = 5*sigma_n;end    
    subplot(NChannels,1,ch);plot(timeSegment*1000,signal);hold on;
    subplot(NChannels,1,ch);plot(timeSegment*1000,threshold*ones(size(timeSegment)));
    
    s_new = round(s(s < max(lengthSegment)));%rounding because we are plotting down sampled data
    subplot(NChannels,1,ch);plot(timeSegment(1,s_new)*1000,signal(s_new),'r.');
    ylabel('amp. [{\mu}V]')
end
xlabel('time [ms]');
suptitle ('Task 1 - Figure 2');

% %% figure 2 prime
% % overlayed plots
% figure(202);
% for ch = 1:NChannels
%     original_signal = x(lengthSegment,ch);
%     signal = y(lengthSegment,ch);
% 
%     sigma_n = median(abs(y(:,ch))/0.6745);
%     if strcmp(spikeType,'extracellular');threshold = -5*sigma_n;else threshold = 5*sigma_n;end    
%     
%     subplot(NChannels,1,ch);plot(timeSegment*1000,original_signal);hold on;
%     subplot(NChannels,1,ch);plot(timeSegment*1000,signal);
%     subplot(NChannels,1,ch);plot(timeSegment*1000,threshold*ones(size(timeSegment)));
%     
%     s_new = round(s(s < max(lengthSegment)));%rounding because we are plotting down sampled data
%     subplot(NChannels,1,ch);plot(timeSegment(1,s_new)*1000,signal(s_new),'r.');
%     ylabel('amp. [{\mu}V]')
%     ylim([-100,100]);
% 
% end
% xlabel('time [ms]');
% suptitle ('Task 1 - Figure 2 - Overlaied');

%% figure 3
% a - plotting first 100 spikes detected
figure(103);hold on
n_spikes_to_show = 10;

%uncomment to plot unaligned data
singleSpikeTraceTime =  0:Ts:(spikeWindow-1)*Ts;

for ch = 1:NChannels
    subplot(sqrt(NChannels),sqrt(NChannels),ch);hold on;
    for spike_index = 1:n_spikes_to_show
        if all(w(:,spike_index,ch)) % if spike numbers are not equal zeros are used. skip those
            plot(singleSpikeTraceTime*1000,w(:,spike_index,ch));
            ylim([-100,100]);
        end
    end
    xlabel('time [ms]'); ylabel('amp. [{\mu}V]');

end
suptitle ('Task 1 - Figure 3.a')

% b - plotting largest 100 spikes detected
figure(104);hold on
for ch = 1:NChannels
    subplot(sqrt(NChannels),sqrt(NChannels),ch);hold on;
    %get amplitude for peaks
    spike_amplitudes = zeros(1,length(s));
    for spike_index = 1:length(s)
        spike_amplitudes(1,spike_index) = y(round(s(spike_index)),ch);
    end
    [~,largest_spikes_idx] =  sort(spike_amplitudes);
    largest_spikes_idx(1:n_spikes_to_show);

    for spike_index = largest_spikes_idx(1:n_spikes_to_show)
        if all(w(:,spike_index,ch)) % if spike numbers are not equal zeros are used. skip those
            plot(singleSpikeTraceTime*1000,w(:,spike_index,ch));
%             ylim([-200,120]);
        end
    end
    xlabel('time [ms]'); ylabel('amp. [{\mu}V]');

end
suptitle ('Task 1 - Figure 3.b')

%% figure 4
if NChannels==4
    figure(400);

    subplot(231);
    scatter(b(:, 1), b(:, 4),'.');
    xlabel('Channel 1');
    ylabel('Channel 2');

    subplot(232);
    scatter(b(:, 1), b(:, 7), '.');
    xlabel('Channel 1');
    ylabel('Channel 3');

    subplot(233);
    scatter(b(:, 1), b(:, 10),'.');
    xlabel('Channel 1');
    ylabel('Channel 4');

    subplot(234);
    scatter(b(:, 4), b(:, 7),'.');
    xlabel('Channel 2');
    ylabel('Channel 3');

    subplot(235);
    scatter(b(:, 4), b(:, 10),'.');
    xlabel('Channel 2');
    ylabel('Channel 4');

    subplot(236);
    scatter(b(:, 7), b(:, 10),'.');
    xlabel('Channel 3');
    ylabel('Channel 4');

    suptitle('Task 1 - Figure 4: 1st PCA of channels');
end
end