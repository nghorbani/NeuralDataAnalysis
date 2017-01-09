set(0,'DefaultFigureWindowStyle','docked')
%%
figure(100);
[X, ~] = sampleGenerator();
%%
figure(200);
K = 3;
[mu, sigma, priors] = expectMaximize(K, X);
I = assignClusters(mu, sigma, priors, X, K);
plotGaussianMixture(I, mu, sigma, X);

%%
figure(300);maxK = 4;
plotBIC(X,maxK);

%%
%load NDA_task1_results
[mu, Sigma, priors, df, assignments] = sortSpikes(b);
K = 7 ;
[mu, Sigma, priors] = expectMaximize(K, b);
assignments = assignClusters(mu, Sigma, priors, b, K);

%figure(401);
%plotBIC(b, 10);

figure(402);
subplot(2, 3, 1);
muplot = [mu(:, 1) mu(:, 4)];
sigmaplot = [Sigma(1, 1, :) Sigma(1, 4, :); Sigma(1, 4, :) Sigma(4, 4, :)];
bplot = [b(:, 1), b(:, 4)];
plotGaussianMixture(assignments, muplot, sigmaplot, bplot);
xlabel('Channel 1');ylabel('Channel 2');

subplot(2, 3, 2);
muplot = [mu(:, 1) mu(:, 7)];
sigmaplot = [Sigma(1, 1, :) Sigma(1, 7, :); Sigma(1, 7, :) Sigma(7, 7, :)];
bplot = [b(:, 1), b(:, 7)];
plotGaussianMixture(assignments, muplot, sigmaplot, bplot);
xlabel('Channel 1');ylabel('Channel 3');

subplot(2, 3, 3);
muplot = [mu(:, 1) mu(:, 10)];
sigmaplot = [Sigma(1, 1, :) Sigma(1, 10, :); Sigma(1, 10, :) Sigma(10, 10, :)];
bplot = [b(:, 1), b(:, 10)];
plotGaussianMixture(assignments, muplot, sigmaplot, bplot);
xlabel('Channel 1');ylabel('Channel 4');

subplot(2, 3, 4);
muplot = [mu(:, 4) mu(:, 7)];
sigmaplot = [Sigma(4, 4, :) Sigma(4, 7, :); Sigma(4, 7, :) Sigma(7, 7, :)];
bplot = [b(:, 4), b(:, 7)];
plotGaussianMixture(assignments, muplot, sigmaplot, bplot);
xlabel('Channel 2');ylabel('Channel 3');

subplot(2, 3, 5);
muplot = [mu(:, 4) mu(:, 10)];
sigmaplot = [Sigma(4, 4, :) Sigma(4, 10, :); Sigma(4, 10, :) Sigma(10, 10, :)];
bplot = [b(:, 4), b(:, 10)];
plotGaussianMixture(assignments, muplot, sigmaplot, bplot);
xlabel('Channel 2');ylabel('Channel 4');

subplot(2, 3, 6);
muplot = [mu(:, 7) mu(:, 10)];
sigmaplot = [Sigma(7, 7, :) Sigma(7, 10, :); Sigma(7, 10, :) Sigma(10, 10, :)];
bplot = [b(:, 7), b(:, 10)];
plotGaussianMixture(assignments, muplot, sigmaplot, bplot);
xlabel('Channel 3');ylabel('Channel 4');