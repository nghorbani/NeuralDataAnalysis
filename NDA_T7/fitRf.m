function rf = fitRf(sp,stim,tsteps)

% rf = fitRf(sp,stim)
%   estimate the linear receptive field rf from the binned spike train sp 
%   and the stimulus stim for an LNP neuron with exponential nonlinearity.
%
%   sp: 1 x ceil(T/dt)          vector of spike counts in time bins of width dt
%
%   stim: 225 x ceil(T/dt)      matrix with +1/-1 entries indicating which
%                               pixels of the stimulus were brighter or less 
%                               bright than the background in each time frame
%
%   tsteps: scalar              specifies number of timesteps into the past
%
%   rf: 225 x tsteps            matrix containing the receptive field of the neuron
%                               at tsteps time lags of size dt
%
% PHB 2012-06-21
[m,n] = size(stim);
w0 = zeros(tsteps*m,1);

stim_aug = zeros(tsteps*m,n);
for shift=1:tsteps;
    stim_aug((shift-1)*m+1:shift*m,:) = circshift(stim,[1,shift-1]);
end

rf = minimize(w0, @logLikLnp, 1000, sp, stim_aug);

end