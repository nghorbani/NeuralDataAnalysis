function K = optimizeK(data)

K = 1;
bic_before = inf;
foundK = false;
while(~foundK)
    [mu, sigma, priors] = expectMaximize(K, data);
    bic = computeBIC(mu, sigma, priors, data);
    
    if (bic > bic_before)
        foundK = true;
        K = K -1;
    else
        bic_before = bic;
        K = K + 1
    end
end

end