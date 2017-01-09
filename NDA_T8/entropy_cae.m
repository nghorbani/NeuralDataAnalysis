function H = entropy_cae(p)

% function H = entropy_cae(p)
%   p   vector with observed frequencies of all words
%   H   coverage adjusted estimate of entropy

N = sum(p);
C = 1 - sum(p==1) / N;
p = p(p > 0) .* C ./ N;
one = ones(size(p));
H = - sum( p .* log2(p) ./ ( one - ( one - p).^N ) );