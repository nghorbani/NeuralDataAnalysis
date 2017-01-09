function [p, q, qdistr] = testTuning(dirs, counts)
% Test significance of orientation tuning by permutation test.
%   [p, q, qdistr] = testTuning(dirs, counts) computes a p-value for
%   orientation tuning by running a permutation test on the second Fourier
%   component.
%
%   Inputs:
%       counts      matrix of spike counts as returned by getSpikeCounts.
%       dirs        vector of directions (#directions x 1)
%
%   Outputs:
%       p           p-value
%       q           magnitude of second Fourier component
%       qdistr      sampling distribution of |q| under the null hypothesis

iters = 1000;
[~, q] = fitCos(dirs, counts);
q = abs(q);
qdistr = zeros(iters, 1);

for i=1:iters
    rcounts = counts(:, randperm(length(dirs)));
    [~, qv] = fitCos(dirs, rcounts);
    qdistr(i) = abs(qv);
end

p = length(qdistr(qdistr >= q))/iters;
%fraction of times that the magnitude of qdistr is at least as large as q