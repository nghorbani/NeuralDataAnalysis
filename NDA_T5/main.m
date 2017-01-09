% %load results from previous tasks
clear all;close all;clc
load NDA_task3_results
load NDA_stimulus
%clc;close all
%%
set(0,'DefaultFigureWindowStyle','docked')
saveplots = 1;
for i = 1 : numel(spikeTimes)
    figure(100+i);
    plotRasters(spikeTimes{i}, stimulusOnset, direction, stimulusDuration)
    %suptitle(sprintf('Rasterplot Trace #%d',i));
    if saveplots;print(num2str(100+i),'-dpng');end;
    
    figure(200+i);
    plotPsth(spikeTimes{i}, stimulusOnset, direction, stimulusDuration)
    %suptitle(sprintf('PSTH Trace #%d',i));
    if saveplots;print(num2str(200+i),'-dpng');end;

    figure(300+i);
    opt_bin = findOptimalBinning(spikeTimes{i}, stimulusOnset, direction, stimulusDuration,1);
    %suptitle(sprintf('Optimal bin Width Trace #%d',i));
    if saveplots;print(num2str(300+i),'-dpng');end;

    figure(400);subplot(410+i);    
    modulationRatio = linearityIndex(spikeTimes{i}, stimulusOnset, direction, stimulusDuration, 50 ,1);
    subplot(410+i);title(sprintf('Modulation Ratio Trace #%d = %2.2f', i, modulationRatio));
end
figure(400);subplot(414);xlabel('Time relative to stimulus onset - ms');
if saveplots;print(num2str(400),'-dpng');end;