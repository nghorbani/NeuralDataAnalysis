function [mu, Sigma, priors, df, assignments] = sortSpikes(b)
% Do spike sorting by fitting a Gaussian or Student's t mixture model.
%   [mu, Sigma, priors, df, assignments] = sortSpikes(b) fits a mixture
%   model using the features in b, which is a matrix of size #spikes x
%   #features. The df output indicates the type of model (Gaussian: df =
%   inf, t: df < inf)
%
%   The outputs are (K = #components, D = #dimensions):
%       mu              cluster means (K-by-D)
%       Sigma           cluster covariances (D-by-D-by-K)
%       priors          cluster priors (1-by-K)
%       df              degrees of freedom in the model (Gaussian: inf)
%       assignments     cluster index for each spike (1 to K)

df = inf;   % you don't need to use this variable unless you want to 
            % implement a mixture of t-distributions

K = optimizeK(b);


[mu, Sigma, priors] = expectMaximize(K, b);
assignments = assignClusters(mu, Sigma, priors, b, K);