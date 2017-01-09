close all; clear all;
load('TrainingData.mat')

correl = zeros(1, length(data));
linear_normal = @(x) (x-min(x(:)))/(max(x(:))-min(x(:)));%+eps;

for dataIdx = 1:length(data)
    figure(100+dataIdx);
    calcTrace = data(dataIdx).GalvoTraces;
    spikeTrace = data(dataIdx).SpikeTraces;
    fr = data(dataIdx).fps;
    inferredRate = estimateRateFromCa(calcTrace,fr);

    subplot(211);bar(linear_normal(inferredRate(1:end,1)));axis('tight')
    title(sprintf('Inferred Spike Rate'));
    subplot(212);bar(linear_normal(spikeTrace(1:end,1)));axis('tight')
    title(sprintf('Gold Truth Spike Rate'))

    
    correl(dataIdx) = corr(spikeTrace(1:end,1), inferredRate(1:end,1));
    suptitle(sprintf('Calc. Trace #%d , correl. %2.2f',dataIdx,correl(dataIdx)))
end

figure(200);
plot(correl);

% baseInfer = diff(calcTrace);baseInfer = [baseInfer;0];
% Ts = 1/Fs;
% time = Ts:Ts:length(calcTrace)*Ts;
% figure(100);
% subplot(311);plot(time,calcTrace);
% subplot(312);plot(time(1:end),baseInfer);
% subplot(313);plot(time(1:end),spikeTrace);
% figure(101);
% [RHO,PVAL] = corr(baseInfer',spikeTrace');
