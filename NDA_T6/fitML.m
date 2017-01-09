function params = fitML(dirs, counts)
% Fit tuning curve using maximum likelihood and Poisson noise model.
%   params = fitML(dirs, counts) fits a parametric tuning curve using
%   maximum liklihood and a Poisson noise model and returns the fitted
%   parameters.
%
%   Inputs:
%       counts      matrix of spike counts as returned by getSpikeCounts.
%       dirs        vector of directions (#directions x 1)

X = fitLS(dirs, counts);
%X = ones(4, 1);
avg_count = mean(counts)';

params = minimize(X, @poissonNegLogLike, 1000, avg_count, dirs);