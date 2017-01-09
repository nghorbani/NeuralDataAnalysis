function H = entropy_est(samp)
% function H = entropy_est(p)
%   p   vector with observed frequencies of all words
%   H   ML estimate of entropy by your favourite advanced method

% https://github.com/pillowlab/PYMentropy
% http://www.stat.columbia.edu/~liam/research/info_est.html

n = accumarray(samp',1); % frequencies of observations

m=length(n); N=sum(n); display_flag=0; k_max=10; %this value of k_max should be sufficient if N<10^6
[a,~]=BUBfunc(N,m,k_max,display_flag);
H=sum(a(n+1)) / log(2);