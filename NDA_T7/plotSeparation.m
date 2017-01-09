function plotSeparation(ws, wt, S)

subplot(2,2,[1,2]);title('Singular values');
plot(diag(S));
xlabel('diagonal component i');ylabel('Value');


subplot(2,2,3);
imagesc(reshape(ws, 15, 15));
title('Spatial filter');

subplot(2,2,4);
plot(wt);
title('Temporal filter');


end