function [ccg, bins] = correlogram(t, assignment, binsize, maxlag)
% Calculate cross-correlograms.
%   ccg = calcCCG(t, assignment, binsize, maxlag) calculates the cross- and
%   autocorrelograms for all pairs of clusters with input
%       t               spike times             #spikes x 1
%       assignment      cluster assignments     #spikes x 1
%       binsize         bin size in ccg         scalar
%       maxlag          maximal lag             scalar
% 
%  and output
%       ccg             computed correlograms   #bins x #clusters x
%                                                               #clusters
%       bins            bin times relative to center    #bins x 1

num_spikes = length(t);
num_clusters = max(assignment);

bins = -maxlag:binsize:maxlag;

numbins = length(bins);

ccg = zeros(numbins, num_clusters, num_clusters);

for spk1=1:num_spikes
    cluster1 = assignment(spk1);
    time1 = t(spk1);
   for spk2 = 1:num_spikes
       if spk1~=spk2
            cluster2 = assignment(spk2);
            time2 = t(spk2);
        
            time_diff = time1-time2;
        
            if abs(time_diff) <= maxlag
                ind = floor(time_diff/binsize) + floor(maxlag/binsize) + 1;
                ccg(ind, cluster1, cluster2) = ccg(ind, cluster1, cluster2) + 1;
            end
       end
   end
end
