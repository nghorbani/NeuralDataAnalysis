function H = entropy_pym(samp)
% function H = entropy_est(p)
%   p   vector with observed frequencies of all words
%   H   ML estimate of entropy by your favourite advanced method

% https://github.com/pillowlab/PYMentropy
% http://www.stat.columbia.edu/~liam/research/info_est.html

[mm, icts] = multiplicitiesFromCounts(samp);
[H, ~] = computeH_PYM(mm, icts);
H = H  / log(2);
