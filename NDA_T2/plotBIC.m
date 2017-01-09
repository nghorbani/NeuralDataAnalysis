function plotBIC(data,max_K)
    BICs = zeros(1,max_K);
    for kIdx=1:max_K
        kIdx
        [mu, sigma, priors] = expectMaximize(kIdx, data);
        BICs(1,kIdx) = computeBIC(mu, sigma, priors,data);
    end
    
    plot(1:max_K,BICs);
    xlabel('# Mixture Components');ylabel('Bayesian Information Criterion');

end

