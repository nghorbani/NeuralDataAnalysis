function plotGaussianMixture(assignments, mus, sigmas, X)

K = length(mus);

ColOrd = get(gca,'ColorOrder');
[m,~] = size(ColOrd);

hold on;
for kIdx=1:K
    ColRow = rem(kIdx,m);if ColRow == 0;ColRow = m;end;Col = ColOrd(ColRow,:);%to set correct color code
    scatter(X(assignments==kIdx, 1), X(assignments==kIdx, 2), '.','MarkerFaceColor',Col);
    plot(mus(kIdx, 1), mus(kIdx, 2), 'ko', 'MarkerSize', 7, 'LineWidth', 2,'Color','k');
    %plotEllipsoid(mus(kIdx, :), sigmas(:,:,kIdx),Col);

% end
% for kIdx=1:K
%     plot(mus(kIdx, 1), mus(kIdx, 2), 'ko', 'MarkerSize', 7, 'LineWidth', 2,'Color','k');
%     %plotEllipsoid(mus(kIdx, :), sigmas(:,:,kIdx),Col);
% 
% end
end