function H = entropy_mle(p)
% function H = entropy_mle(p)
%   p   vector with observed frequencies of all words
%   H   ML estimate of entropy
N = sum(p);
p = p(p > 0) ./ N;
H = - sum(p.*log2(p));