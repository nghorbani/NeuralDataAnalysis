function [sample_data, assignments] = sampleGenerator()
%%
sampleSize = 1000; sampleDim = 2;sampleK = 3;
mus = zeros(sampleK, sampleDim);sigmas = repmat(eye(sampleDim),1,1, sampleK);priors = ones(1, sampleK);
mus(1,:) = [0;0];mus(2,:) = [5;1];mus(3,:) = [0;2];
sigmas(:, :, 1) = [1,0;0,1];sigmas(:, :, 2) = [2,1;1,2];sigmas(:, :, 3) = [1,-.5;-.5,2];
priors(1) = 0.3;priors(2) = 0.5;priors(3) = 0.2;
%%
kIdx =1; samples1 = mvnrnd(mus(kIdx,:), sigmas(:, :, kIdx),sampleSize);
kIdx =2; samples2 = mvnrnd(mus(kIdx,:), sigmas(:, :, kIdx),sampleSize);
kIdx =3; samples3 = mvnrnd(mus(kIdx,:), sigmas(:, :, kIdx),sampleSize);

decision = rand(sampleSize);
assignments = zeros(sampleSize);

sample_data = zeros(sampleSize, 2);
for i=1:sampleSize
    if decision(i) < priors(1)
        sample_data(i, :) = samples1(i, :);
        assignments(i) = 1;
    elseif decision(i) < priors(2)
        sample_data(i, :) = samples2(i, :);
        assignments(i) = 2;
    else
        sample_data(i, :) = samples3(i, :);
        assignments(i) = 3;
    end
end

plotGaussianMixture(assignments, mus, sigmas, sample_data);
end