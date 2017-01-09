function H = entropy_mm(p)
% function H = entropy_mle(p)
%   p   vector with observed frequencies of all words
%   H   ML estimate of entropy with miller-maddow correction
d = sum(p == 0) + 1024 - length(p);
H = entropy_mle(p);
H = H + (d - 1) / (2 .* 1024);