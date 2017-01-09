function [BIC] = computeBIC(mus, sigmas, priors,data)
    K = size(mus,1);
    iterations = 3;
    BICs = zeros(1,iterations);
    for i=1:iterations
        [lenData, dimData] = size(data);
        P = K*(1 + dimData + 0.5*dimData*(dimData-1));
        logLike = logLikelihood(mus, sigmas, priors, data);
        BICs(i) = -2 * logLike + P * log(lenData);
    end
    BIC = min(BICs);
end