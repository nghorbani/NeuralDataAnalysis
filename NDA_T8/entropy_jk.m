function H = entropy_jk(samp)
% function H = entropy_jk(p)
%   samp  observations (samples)
%   H   jackknife estimate of entropy

% jack-knifed entropy estimator (paninski, p. 1198)

N = numel(samp); % #observations
% HJacked = 0;
% for j = 1:N
%     sampJacked = samp;
%     sampJacked(j) = [];
%     fJacked = accumarray(sampJacked',1); % leave on of samples out
%     HmleJacked = entropy_mle(fJacked);
%     HJacked = HJacked + HmleJacked;
% end
Hjack = @(sampJacked) entropy_mle(accumarray(sampJacked,1));
opt = statset('UseParallel',true);
HJacked = sum(jackknife(Hjack, samp,'Options',opt));
fi = accumarray(samp',1); % frequencies of observations
Hmle = entropy_mle(fi);
H = N*Hmle - ((N-1)/N)*HJacked;
