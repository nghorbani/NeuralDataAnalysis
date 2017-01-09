function [mus, sigmas, priors] = expectMaximize(K, data)
    %rng(100);
    [lenData, dimData] = size(data);
%%  Parameter initialization
    mu = mean(data);
    sigma = cov(data);
    mus = mvnrnd(mu, sigma, K);
    % mixture coefficients and sigmas are set non-randomly
    priors = ones(1, K)/K;
    sigmas = repmat(sigma,1,1, K);
%% EM Steps
% aim is to find a local maximum of log liklihood function
    LogLike = abs(logLikelihood(mus, sigmas, priors,data)); % for some stopping mechanism
    for iteration = 1:50 
        gammas = zeros(lenData, K); % responsibilities;

        %% Expectation step
        
        % computes the expectation of the complete data log-likelihood using the posterior
        % probability that each data point belongs to the kth cluster based on the current parameters

        for dataIdx=1:lenData
            for kIdx=1:K
                %iteration,dataIdx,kIdx
                gammas(dataIdx, kIdx) = priors(kIdx)* mvnpdf(data(dataIdx,:),mus(kIdx, :), sigmas(:, :, kIdx));
            end
            gammas(dataIdx,:) = gammas(dataIdx,:)./sum(gammas(dataIdx,:));%posterior probability
        end
    
        %% Maximization step
        Nk = sum(gammas,1);
        for kIdx=1:K
            % update means
            newMean = zeros(1,dimData);
            for dataIdx=1:lenData
                newMean = newMean + gammas(dataIdx, kIdx) .* data(dataIdx, :);
            end
            mus(kIdx, :) = newMean ./ Nk(kIdx);
            
            % update covariances
            newSigma = zeros(dimData);
            for dataIdx=1:lenData
                centeredData = data(dataIdx, :) - mus(kIdx, :);
                newSigma = newSigma + gammas(dataIdx, kIdx) * (centeredData'*centeredData);
            end
            sigmas(:, :, kIdx) = newSigma ./ Nk(kIdx);
            
            % update mixing coefficients
            priors(kIdx) = Nk(kIdx)/lenData;
        end
        %% Stop criteria - loglike monotonically increasing
        newLogLike = abs(logLikelihood(mus, sigmas, priors,data));
        if abs(LogLike-newLogLike)<20 % some stopping mechanism. not sure if correct
            break
        else
            LogLike = newLogLike;
        end
    end
end