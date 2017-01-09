function I = assignClusters(mu, sigma, priors, X, K)

resp = zeros(length(X), K);%responsibilities
for dataIdx=1:length(X)
    for kIdx=1:K
    	resp(dataIdx, kIdx) = priors(kIdx)* mvnpdf(X(dataIdx,:),mu(kIdx, :), sigma(:, :, kIdx));
    end
    resp(dataIdx,:) = resp(dataIdx,:)./sum(resp(dataIdx,:));
end


I = zeros(length(X), 1);
for dataIdx=1:length(X)% so for each datapoint a value from 1-k will be set 
    [~, I(dataIdx)] = max(resp(dataIdx, :));
end