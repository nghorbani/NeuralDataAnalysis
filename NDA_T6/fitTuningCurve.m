function params = fitTuningCurve(dirs, counts)
% Fit parametric tuning curve.
%   params = fitTuningCurve(dirs, counts) fits a parametric tuning curve
%   and returns the fitted parameters. Inputs:
%       counts      matrix of spike counts as returned by getSpikeCounts.
%       dirs        vector of directions (#directions x 1)
