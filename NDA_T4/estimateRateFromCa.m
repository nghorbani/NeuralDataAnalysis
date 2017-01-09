function inferredRate = estimateRateFromCa(F, fr)
% implementation of spike train inference based on approximation for MAP 
% doi: 10.1152/jn.01073.2009 and arXiv:1409.2903 [q-bio.NC]
% in some places inspired by the code from respective authers

if nargin<2, fr=10; end

% normalizing F
F = (F-min(F))/(max(F)-min(F));

% parmeters
p = struct;

% variables determined by the data
T = length(F);
p.dt = 1/fr;

%initializing parameters
p.sig = mad(F',1)*1.4826;% median of the absolute deviations from the median
p.gam   = 1-p.dt; % according to paper
p.lam   = 1; % Hz
p.a = median(F);%page 8
p.b = median(F);%since spiking is sparse

%% compute posterior based on initialized values
inferredRate = optimize(F,p);

end
