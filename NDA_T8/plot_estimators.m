function plot_estimators(H,H_mle,H_mm,H_cae,H_jk,H_est,H_pym, sampleSz,s)
% function for plotting the different estimators
%   H       scalar with true entropy
%   H_mle   matrix nSampleSz x nRuns of entropy estimates by mle estimator
%   H... equivalently
%


lw = 2;
ms = 2;

figure
ma = max(reshape([H_mle,H_mm,H_cae,H_jk],[],1));
mi = min(reshape([H_mle,H_mm,H_cae,H_jk],[],1));
line([sampleSz(1)*.7 sampleSz(end)*1.3],[H H],'color','k'), hold on
plot(sampleSz,mean(H_mle,2),'rs-','linewidth',lw,'markersize',ms), hold on
plot(sampleSz,mean(H_mm,2),'bs-','linewidth',lw,'markersize',ms), hold on
errorbar(sampleSz,mean(H_jk,2),std(H_jk,[],2),'cs-','linewidth',lw,'markersize',ms), hold on
errorbar(sampleSz,mean(H_cae,2),std(H_cae,[],2),'gs-','linewidth',lw,'markersize',ms), hold on
plot(sampleSz,mean(H_est,2),'ys-','linewidth',lw,'markersize',ms), hold on
plot(sampleSz,mean(H_pym,2),'ms-','linewidth',lw,'markersize',ms), hold on
% errorbar(sampleSz,mean(H_est,2),std(H_est,[],2),'ys-','linewidth',lw,'markersize',ms), hold on
% errorbar(sampleSz,mean(H_pym,2),std(H_pym,[],2),'ms-','linewidth',lw,'markersize',ms), hold on

set(gca,'xscale','log')
title(s)
xlabel('Number of Samples (N)')
ylabel('Entropy (bits)')
xlim([sampleSz(1)*.7 sampleSz(end)*1.3])
ylim([0.95*mi 1.05*ma])

legend('H','MLE','MLE+MM','JK','CAE','BUB','PYM','location','southeast'); legend('boxoff')
