% load data
clc;clear all;close all
load NDA_task6_data
load NDA_stimulus
set(0,'DefaultFigureWindowStyle','docked')

saveplots = 1;
% test for significant tuning
dirs = deg2rad(unique(direction));
plotdirs = deg2rad([0:10:360]');

nCells = numel(spikeTimes);
pVals = zeros(1, nCells);
for cellIdx = 1 : nCells
    mK = getSpikeCounts(spikeTimes{cellIdx}, stimulusOnset, direction, stimulusDuration);
    [pVals(cellIdx), q, qdistr] = testTuning(dirs, mK);
end
fprintf('%d of %d cells are tuned at p < 0.01\n', sum(pVals < 0.01), nCells)

%% actual plot

for figIdx = 1:nCells%length(cells)
    cellIdx = figIdx;
    
    mK = getSpikeCounts(spikeTimes{cellIdx}, stimulusOnset, direction, stimulusDuration);
    
    figure(100+figIdx);suptitle(sprintf('cell #%d',cellIdx))
    
    ax221 = subplot(221); hold on;title('a.')
    errorbar(dirs, mean(mK), sqrt(var(mK)),'b.');
    f = fitCos(dirs, mK); plot(dirs, f,'r'); % fitted cosine function
    ylimit = get(ax221,'YLim');
    xlim([0 2*pi]);ylim(ylimit);
    xlabel('direction - radians'); ylabel('#spikes');
    legend('avg. response','cosine fit');
    ax221.XTick = [0:pi/2:2*pi];ax221.XTickLabel ={'0';'\pi/2';'\pi';'3\pi/2';'2\pi'};
    
    ax222 = subplot(222); hold on;title('b.') 
    [pVal, q, qdistr] = testTuning(dirs, mK);
    histogram(qdistr);
    line([q q],get(ax222,'YLim'),'Color',[1 0 0]);
    text(ax222,0.75,0.75,sprintf('p = %.4f',pVal),'Units','normalized')


    ax223=subplot(223); hold on;title('c.')
    params = fitLS(dirs, mK);
    y = tuningCurve(params, plotdirs);
    errorbar(dirs, mean(mK), sqrt(var(mK)),'b.');
    plot(plotdirs, y,'r');
    xlim([0 2*pi]); ylim(ylimit);
    xlabel('direction - radians'); ylabel('#spikes');
    legend('avg. response','von Mises model');
    ax223.XTick = [0:pi/2:2*pi];ax223.XTickLabel ={'0';'\pi/2';'\pi';'3\pi/2';'2\pi'};

    ax224 = subplot(224); hold on;title('d.')
    params = fitML(dirs, mK);
    y = tuningCurve(params, plotdirs);
    errorbar(dirs, mean(mK), sqrt(var(mK)),'b.');
    plot(plotdirs, y,'r');
    xlim([0 2*pi]); ylim(ylimit);
    xlabel('direction - radians'); ylabel('#spikes');
    legend('avg. response','Poisson noise model');
    ax224.XTick = [0:pi/2:2*pi];ax224.XTickLabel ={'0';'\pi/2';'\pi';'3\pi/2';'2\pi'};
    if saveplots;print(num2str(100+figIdx),'-dpng');end;

end