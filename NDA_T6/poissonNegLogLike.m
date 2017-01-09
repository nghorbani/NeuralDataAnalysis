function [logLike, gradient] = poissonNegLogLike(p, counts, theta)
% Negative log likelihood for Poisson spike count and von Mises tuning.
%   [logLike, gradient] = poissonNegLogLike(p, counts, theta) returns the
%   log-likelihood (and its gradient) of the von Mises model with Poisson
%   spike counts.
%
%   Inputs:
%       p           four-element vector of tuning parameters
%       counts      column vector of spike counts
%       theta       column vector of directions of motion (same size as
%                   spike counts)
%
%   Outputs:
%       logLike     negative log-likelihood
%       gradient    gradient of negative log-likelihood with respect to 
%                   tuning parameters (four-element column vector)
n = length(theta);

y = tuningCurve(p, theta);
logLike = sum(y - counts.*log(y));

gradient = zeros(4, 1);
phi = p(1).*ones(n, 1);
kappa = p(2);
nu = p(3);
alpha = p(4).*ones(n, 1);

grad1 = y - counts;

% gradient with respect to phi
phi1 = 2.*kappa.*sin(2.*(theta - phi));
phi2 = nu.*sin(theta - phi);
gradient(1) = sum((phi1 + phi2).*grad1);

% gradient with respect to kappa
kappa1 = cos(2.*(theta- phi)) - ones(n, 1);
gradient(2) = sum(kappa1.*grad1);

% gradient with respect to nu
nu1 = cos(theta -phi) - ones(n, 1);
gradient(3) = sum(nu1.*grad1);

% gradient with respect to alpha
gradient(4) = sum(grad1);