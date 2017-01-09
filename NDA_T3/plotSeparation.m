function plotSeparation(b, mu, Sigma, priors, assignment, varargin)
% Plot cluster separation by projecting on LDA axes
%   plotSeparation(b, mu, Sigma, priors, assignment) visualizes the cluster
%   separation by projecting the data on the LDA axis for each pair of
%   clusters. Each column is normalized such that the left (i.e. first)
%   cluster has zero mean and unit variances. The LDA axis is estimated
%   from the model.

K = size(mu, 1);

colors = distinguishable_colors(K);

for k1=1:K
    for k2=1:K
       if k1~=k2
           S = Sigma(:,:,k1) + Sigma(:,:,k2);
           w = S \ (mu(k1, :) - mu(k2, :))';
           w = w/norm(w);
           data1 = b(assignment==k1, :) * w;
           data2 = b(assignment==k2, :) * w;
           
           hist_mean = mean(data1);
           stdev = std(data1);
           
           data1 = (data1 - hist_mean) ./ stdev;
           data2 = (data2 - hist_mean) ./ stdev;
           
           subplot(K, K, K*(k1-1)+k2);
           
           hold on;
           histogram(data1, 'FaceColor', colors(k1, :), 'EdgeColor', colors(k1, :));
           histogram(data2, 'FaceColor', colors(k2, :), 'EdgeColor', colors(k2, :));
           axis off;
           hold off;
       end
    end
end
       