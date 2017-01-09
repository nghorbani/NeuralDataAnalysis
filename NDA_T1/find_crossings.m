function [peak_idxs, cross_ups, cross_downs] = find_crossings(x, threshold,interpolation_factor,Fs, spike_type)
% peak find routine. will return all the sample points where the
% abs(peak>threshold)
if nargin<3
    spike_type = 'extracellular';
end
cross_ups = []; % where signal goes above threshold
cross_downs = []; % where signal comes below threshold
% the above two variables are for when we want to detect peaks rather than
% crossing points
peak_idxs = []; %indices where peaks above threshold occur
discardWindow = 10; %samples to discard, no peaks closed than this

i = 0;
set=0;
if strcmp(spike_type,'intracellular')
    while 1 % using while instead of for so to jump over discard window
        if i < length(x); i = i+1; else break; end;
        if set == 0
            if x(i)>threshold % no equal to threshold checked
                set = 1;
                cross_up = i;
                cross_ups = [cross_ups; cross_up];
                i = i + discardWindow;
                continue
            end
        else
           if x(i)<=threshold
               set = 0;
               cross_down = i;
               cross_downs = [cross_downs; cross_down];
               spikeHead = x(cross_up:cross_down);
               [smoothedSpikeHead,~] = smooth(spikeHead,interpolation_factor,Fs);

               [~,peak_index] = max(smoothedSpikeHead);
               peak_index = peak_index/interpolation_factor;

               peak_idxs = [peak_idxs;cross_up + peak_index];%addition because of varied search window
           end
        end
    end
else
     while 1 % using while instead of for so to jump over discard window
        if i < length(x); i = i+1; else break; end;
        if set == 0
            if x(i)<threshold % no equal to threshold checked
                set = 1;
                cross_up = i;
                cross_ups = [cross_ups; cross_up];
                continue
            end
        else
           if x(i)>=threshold
               set = 0;
               cross_down = i;
               cross_downs = [cross_downs; cross_down];
               spikeHead = x(cross_up:cross_down);
               [smoothedSpikeHead,~] = smooth(spikeHead,interpolation_factor,Fs);

               [~,peak_index] = min(smoothedSpikeHead);
               peak_index = peak_index/interpolation_factor;

               peak_idxs = [peak_idxs;cross_up + peak_index];%addition because of varied search window
           end
        end
    end
end
end
