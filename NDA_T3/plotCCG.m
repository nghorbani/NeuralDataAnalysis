function plotCCG(t, assignment, varargin)
% Plot cross-correlograms of all pairs.
%   plotCCG(t, assignment) plots a matrix of cross(auto)-correlograms for
%   all pairs of clusters. Inputs are:
%       t           vector of spike times           #spikes x 1
%       assignment  vector of cluster assignments   #spikes x 1

[ccg, bins] = correlogram(t, assignment, 0.5, 20);

K = size(ccg, 2);

colors = distinguishable_colors(K);
for k=1:K
    for l=1:K
        subplot(K, K, K*(k-1)+l);
        color = [0 0 0];
        
        if (k == l)
            color = colors(k, :);
        end
        
        bar(bins, ccg(:, k, l), 'FaceColor', color, 'EdgeColor', color);
        axis([-20 20 0 inf]);
        axis off
    end
end