function [Um]=PCA(data)

%remove zero spikes
new_data = [];
for idx = 1:size(data,2)
    if all(data(:,idx))
        new_data = [new_data,data(:,idx)];
    end
end
data = new_data;

Cov_data = cov(data');

[U, D, ~] = svd(Cov_data);

diag_D = diag(D);
sum_D = sum(diag_D); % total variance
var_explained = sum(diag_D(1:3)) / sum_D;

fprintf('Variance explained: %2.2f%%\n', var_explained*100);

PCs = 3;
Um = U(:,1:PCs);

end
