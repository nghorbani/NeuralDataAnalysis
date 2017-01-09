%% Task 7.1: fit instantaneous receptive field
clear all; close all; clc;
set(0,'DefaultFigureWindowStyle','docked')
saveplots = 1;

% parameter settings
par.T = 200000;                     % duration of experiment in ms
par.dt = 20;                        % bin width in ms
par.gabor = [0.2 0.05 .3 pi/2];     % settings for spatial rf (gabor)
par.temp = [NaN NaN NaN 1];         % settings for temporal kernel (raised cosine)
par.stimtype = 'gaussian';
par.nonlin = 'exp';

%% Task 7.1 get spike counts
par.temp = [NaN NaN NaN 1];
[c s w_true] = sampleLnp(par);

% fit receptive field
w_est = fitRf(c,s,1);

% visualize true and estimated receptive field (on same scale)
figure(101);
[zmin,zmax] = get_colormap(w_est);
subplot(121);imagesc(reshape(w_true,15,15),[zmin,zmax]);title('W_{True}');
subplot(122);imagesc(reshape(w_est,15,15),[zmin,zmax]);title('W_{Estimated}');
suptitle('Receptive Field Estimation');
if saveplots;print(num2str(101),'-dpng');end;


%% Task 7.2: fit spatio-temporal receptive field
par.temp = [1 0.1 pi/2 5];
tsteps = par.temp(4);

% get spike counts
[c s w_true] = sampleLnp(par);
w_true= reshape(w_true,225,[]);

% fit receptive field
w_est = fitRf(c,s,tsteps);
w_est = reshape(w_est,225,[]);

% visualize true and estimated receptive field (on same scale) for the
% different time bins
figure(102);
[zmin,zmax] = get_colormap(w_est);
for tIdx = 1:tsteps
    subplot(2,tsteps,tIdx);imagesc(reshape(w_true(:,tIdx),15,15),[zmin zmax]);%title(sprintf('tstep_{%d}',tIdx));  
    subplot(2,tsteps,tsteps+tIdx);imagesc(reshape(w_est(:,tIdx),15,15),[zmin zmax]);%title(sprintf('tstep_{%d}',tIdx));
    xlabel(sprintf('\\Deltat = %2.1f',(1-tIdx)))
end
subplot(2,tsteps,1);ylabel('W_{True}')
subplot(2,tsteps,tsteps+1);ylabel('W_{Estimated}')
if saveplots;print(num2str(102),'-dpng');end;

%% Task 7.3: recover space and time kernels

% space-time separation of true receptive field
[ws, D, wt] = sepSpaceTime(w_true);
[ws_est, D_est, wt_est] = sepSpaceTime(w_est);

% visualize true and estimated spatial receptive field (on same scale) and
% the true and estimated time kernels

figure(103);
plotSeparation(ws, wt, D);
if saveplots;print(num2str(103),'-dpng');end;

% it is possible that SVD inverts the temporal component
% if the peak points downward, flip sign as needed:
wt_est = wt_est * sign(mean(wt_est));

figure(104);
plotSeparation(ws_est, wt_est, D_est);
if saveplots;print(num2str(104),'-dpng');end;

%% task 7.4: fit spatio-temporal receptive field to data
data = load('rf_data.mat');

c = data.spk;
s = data.stim;

figure(105);
% fit receptive field
for shift = 1 : 10;
    w_est = fitRf(c(shift:end),s(:,1:end-shift+1),1);
    subplot(3, 4, shift);
    [zmin,zmax] = get_colormap(w_est);
    imagesc(reshape(w_est, 15, 15),[zmin,zmax])
    xlabel(sprintf('\\Deltat = %dms',(1-shift)*10))

end
if saveplots;print(num2str(105),'-dpng');end;

% ADD YOUR CODE HERE ....


