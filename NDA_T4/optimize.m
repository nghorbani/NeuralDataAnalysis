function n = optimize(F,P)
    % The two formulas which model the relationships between spikes,
    % calcium concentration and fluorescence:
    % (Pnevmatikakis(2014) Chapter 2)
    %
    % C(t) = P.gam*C(t-1) + n(t)
    % F(t) = P.a*C(t) + P.b + noise(0, P.sigma^2)
    %
    % Objective function for optimization:
    % argmin{[c_in;C]} sum(n) = argmin{[c_in;C]} sum(G*C)
    % with the constraints:
    % 
    % Fluorescence inferred from C is equal up to noise
    % ||F - C - B|| <= sqrt(P.sigma^2*T)
    %
    % Spikes are positive
    % G*C>= 0, c_in >= 0
    %
    % With Lagrange multipliers we get the actual used objective function:
    % n = G*C
    % C = argmin sum(G*C) + z*(||F-C-B||^2 - P.sigma^2T) - mu*sum(log(G*C))

    T = length(F);
    
    % n = G*C
    G = zeros(T, T+1);
    G(1, 1:2) = [-1 1];
    G(2, 1) = -P.gam;
    for i=2:T
        G(i, i:i+1) = [-P.gam 1];
    end
    
    % gamma is the derivative of sum(G*C) in respect to C
    gamma = (1 - P.gam) .* ones(T+1, 1);
    gamma(1) = P.gam - 1;
    
    % Fluorescence background
    B = P.b .* ones(T, 1);
    
    % Lagrangian multiplier
    % z is for the constraint || F - C - B || <= sigma^2*T
    % mu is for sum(log(G*C)) which ensures to have only positive spikes.
    z = 1;
    mu = 1;
    
    %parameters for line search
    c = 0.5;
    tau = 0.5;

    % C(1) is the initial calcium concentration c_in
    C = [1; (F - B) .*(F>B)];
    
    % Compute objective function
    old_post = sum(G*C)+z*(norm(F-C(2:end)-B)^2-P.sig^2*T) - mu*(sum(log(G*C))+log(C(1)));
    post = old_post;
    while (post < old_post)
        old_post = post;
        s = 1;

        % Compute gradient
        c1 = zeros(T+1, 1); c1(1) = C(1)^-1;
        gC = gamma -2*z*[0; (F-C(2:end)-B)]-mu*((G*C).^-1 + c1);
        
        % initialize parameters for line search
        m = -norm(gC);
        t = -c*m;
        
        % Perform backtracking line search to find optimal step size s
        C_new = C-s*gC;
        post1 = sum(G*C_new)+z*(norm(F-C_new(2:end)-B)^2-P.sig^2*T) - mu*(sum(log(G*C_new))+log(C_new(1)));
        while (post - post1 < s*t)
            s = tau*s;
            C_new = C - s*gC;
            post1 = sum(G*C_new)+z*(norm(F-C_new(2:end)-B)^2-P.sig^2*T) - mu*(sum(log(G*C_new))+log(C_new(1)));
        end
            
        C = C_new;
        post = post1;
        
        % Set parameters for a line search to find new z value
        s = 1;
        gz = norm(F-C(2:end)-B)^2-P.sig^2*T;
        m = -gz;
        t = -c*m;
        
        % Find new value of z by backtracking line search
        z_new = z - s*gz;
        while (z- z_new < s*t)
            s = tau*s;
            z_new = z - s*gz;
        end
        z = z_new;
        
        % initialize parameters for line search of mu
        s = 1;
        gmu = sum(log(G*C))+C(1);
        m = -gmu;
        t = -c*m;
        
        % perform backtracking line search to find optimal update of mu
        mu_new = mu - s*gmu;
        while(mu - mu_new < s*t)
            s = tau*s;
            mu_new = mu - s*gmu; 
        end
        mu = mu_new;
    end
    
    n = G*C;
    
    % Subtract spiking background
    med = quantile(n, 0.75);
    n = (n-2.*med.*ones(T, 1)) .*(n>2.*med);
end