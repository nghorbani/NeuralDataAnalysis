function [f, q] = fitCos(dirs, counts)
% Fit cosine tuning curve.
%   f = fitCos(dirs, counts) fits a cosine tuning curve by projecting on
%   the second Fourier component. Returns f, a vector of estimated spike
%   counts given the cosine tuning curve.
%
%   Inputs:
%       counts  matrix of spike counts as returned by getSpikeCounts.
%       dirs    vector of directions (#directions x 1)

m = mean(counts);

rads = dirs;%deg2rad(dirs); %dirs.*2*pi./360;
v = exp(2.*1i.*rads)/4;

% projection onto second Fourier component 
q = m*v;

f = mean(m) + conj(q) .* v + q .* conj(v);
