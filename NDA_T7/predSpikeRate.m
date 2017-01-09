function r_est = predSpikeRate(w_est,s)

%  c_est = predSpikeRate(w_est,s)
%   Predict the spike rate caused by stimulus s given the estimated
%   receptive field w_est, assuming a purely linear model 
%   
%           r_est = w_est' * s.
%
%   w_est   estimated receptive field (225 x 1)
%   s       stimulus matrix (225 x T/dt)
%
%   r_est   predicted spike count vector 
%
%   PHB 2012-06-25



tsteps = size(w_est,2);
nT = size(s,2);

r_est = zeros(1,size(s,2));
for t=tsteps:nT
    r_est(t) = sum(sum(s(:,(t-tsteps+1):t).*w_est,2),1);
end

