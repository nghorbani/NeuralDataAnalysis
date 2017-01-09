function logLike = logLikelihood(mus, sigmas, priors,data)
    K = size(mus,1);
    [lenData, ~] = size(data);
    logLike = 0;
    for dataIdx=1:lenData
        overK = 0;
        for kIdx=1:K
            overK = overK + priors(kIdx)* mvnpdf(data(dataIdx,:),mus(kIdx, :), sigmas(:, :, kIdx));
        end
        logLike = logLike + log(overK);
    end
end