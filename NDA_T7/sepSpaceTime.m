function [ws, D, wt] = sepSpaceTime(w)

% [ws wt] = sepSpaceTime(w)
%   Apply SVD to recover the space and time kernels of the space-time
%   separable recpetive field w.
%
%   w   receptive field (225 x timeSteps)
%
%   ws  spatial component of the receptive field (225 x 1)
%   wt  temporal component of the receptive field (timeSteps x 1)
%
%   PHB 2012-06-25

[U, D, V] = svd(w);
ws = U(:, 1);
wt = V(:, 1);