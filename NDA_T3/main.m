% load data from task 2
set(0,'DefaultFigureWindowStyle','docked')
%load NDA_task1_results
load NDA_task2_results

% diagnostic plots
figure(101);plotWaveforms(w, assignments);
figure(102);plotCCG(t, assignments);
figure(103);plotSeparation(b, mu, Sigma, priors, assignments);
