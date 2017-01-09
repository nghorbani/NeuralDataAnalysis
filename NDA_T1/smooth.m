function [signal_smoothed,timewarp] = smooth(signal,interpolation_factor,Fs)

if nargin < 3
    interpolation_factor = 10;
end

Ts = 1/Fs;

time = Ts:Ts:length(signal)*Ts;
timewarp = Ts:Ts/interpolation_factor:length(signal)*Ts;
signal_smoothed = spline(time,signal,timewarp)';

end