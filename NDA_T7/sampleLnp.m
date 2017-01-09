function [c,s,w] = sampleLnp(par)

% [c s w] = sampelLnp(par)
%   Generates spike counts from a LNP model of a V1 simple cell using a
%   gabor filter as spatial receptive field and a raised cosine function
%   (Pillow 2008) as temporal filter. Both are assumed to be separable.
%
%   Inputs:
%       par.gabor   parameters for the gabor filter (variance, polar
%                   frequencies (2), phase)
%       par.temp    paramters for the temporal compnent (1-3) and number of
%                   time steps (4)
%       par.T       duration of the texperiment in ms
%       par.dt      time step
%
%   Outputs:
%       c           vector of spike counts (1 x par.T/par.dt)
%       s           stimulus matrix (225 x par.T/par.dt)
%       w           'true' receptive field (225 x par.temp(4))
% 
%   Tip:
%       For the receptive field, temporal and spatial dimensions have been 
%       concatenated to vector format. To go back to a 2D spatial x 
%       1 D time = 3D representation, use reshape(w,15,15,par.temp(4)). 
%       Similarly, to visualize a frame of the stimulus, use 
%       reshape(s(:,:,i),15,15).
%
%   PHB 2012-06-18

% set random number generator
rng('default')

%% parameters
T = par.T;
dt = par.dt;
nD = T/dt;

%% generate receptive field
% generate spatial filter
ws = real(gaborfilter(par.gabor));
nS = size(ws,1);

% temporal response filter
nT = par.temp(end);
t = 0:dt:(dt*(nT-1));
wt = SpHist(t,par.temp(1:end-1));

% compute spatial temporal receptive field (space-time separable)
w = reshape(ws,[],1)*wt;

%% generate stimulus

switch par.stimtype
    case 'sparse'       % use sparse noise - only one square set to +1/-1
                        % per stimulus frame
        pos = [];
        for b=1:ceil(nD/nS^2)
            pos = [pos randperm(nS^2)]; %#ok<AGROW>
        end
        pos = pos(1:nD);
        sgn = double(rand(size(pos)) > 0.5); 
        sgn(sgn==0)=-1;

        s = zeros(nS^2,nD);
        for t=1:nD
            s(pos(t),t) = sgn(t);
        end
        s = s*15;

    case 'gaussian'     % use dense Gaussian noise
        s = randn(nS^2,nD);
end

%% generate rate

% convolve receptive field with stimulus
r = zeros(1,nD);
wflip = fliplr(w);
for t=nT:nD
    r(t) = sum(sum(s(:,(t-nT+1):t).*wflip,2),1);
end

% apply nonlinearity
switch par.nonlin
    case 'linear'
        r(r<0) = 0;
    case 'exp'
        r = exp(r);
end


%% generate spike counts
c = zeros(size(r));
for t=1:nD
    c(t) = poissrnd(r(t));
end

function b = SpHist(t,par)

if length(t) > 1
    b = zeros(size(t));
    idx = abs(par(1)*log(t + par(2))-par(3))<pi;
    b(idx) = (1/2)*cos(par(1)*log(t(idx)+ par(2)) - par(3)) + 1/2;
else 
    b = 1;
end




