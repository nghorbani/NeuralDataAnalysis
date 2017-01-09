function y = tuningCurve(p, theta)
% Evaluate tuning curve.
%   y = tuningCurve(p, theta) evaluates the parametric tuning curve at
%   directions theta (in degrees, 0..360). The parameters are specified by
%   a 1-by-k vector p.

n = length(theta);

phi = p(1).*ones(n, 1);
kappa = p(2);
nu = p(3);
alpha = p(4).*ones(n, 1);

cos1 = kappa .* ( cos(2.*(theta-phi)) - ones(n, 1) );
cos2 = nu .* ( cos(theta-phi) - ones(n, 1) );
y = exp(alpha + cos1 + cos2);