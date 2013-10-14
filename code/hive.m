function hive(max_sim_time, dt)
% For now 1:1 re-modelling of the reference paper
    
    % Preallocate space to prevent reallocations
    %B = zeros(1,max_sim_time);
    %H = zeros(1,max_sim_time);
    %f = zeros(1,max_sim_time);
    %F = zeros(1,max_sim_time);

    B(1) = 0;                                          % Uncapped brood
    H(1) = 16000;                                      % Hive bees
    f(1) = 0;                                          % Food storage
    F(1) = 8000;                                       % Foragers
    
    b = 500;                                           % Food effect on brood survival
    v = 5000;                                          % Hive bees effect on brood survival
    tau = 12;                                          % Aging time in days (12 days [2])
    amin = 0.25;                                       % Minimum recruitment
    amax = 0.25;                                       % Food dependent recruitment
    L = 2000;                                          % Laying rate of the queen
    m = 0.3;                                           % Forager death rate
    sigma = 0.75;                                      % Social inhibition strength
    phi = 1/9;                                         % Adult bee emerging factor
    c = 0.1;                                           % Food per forager and day, will vary with advanced model!
                                     % TODO: Implement seasonal changes, etc.
                                     
    coFH = 0.007;                   % Food consumption of adult bees (g)
    coB = 0.018;                    % Food consumption of brood (g)
                                     
    S = @(H, f) f^2/(f^2 + b^2) * H/(H+v);             % Brood survival rate

    R = @(H, F, f) amin + amax*(b^2/(b^2+f^2)) - sigma * (F/(F+H));          % Recruitment function

    
    % Iteration
    for t = 1:dt:max_sim_time
        
        % Function handles
        dB = @(t) L * S(H(t), f(t)) - phi * B(t);                  % Brood change rate
        dH = @(t) phi * B(t - tau) - H(t) * R(H(t), F(t), f(t));     % Rate of change of hive bees > tau
        dHs = @(t) - H(t) * R(H(t), F(t), f(t));                     % Rate of change of hive bees <= tau
        dF = @(t) H(t) * R(H(t), F(t), f(t)) - m*F(t);               % Rate of change of foragers
        df = @(t) c * F(t) - coFH * (F(t) + H(t)) - coB * B(t);     % Food change rate
        
        % Calculate t+1
        B(t + 1) = B(t) + dt * dB(t);
        F(t + 1) = F(t) + dt * dF(t);
        % Hive bees can only emerge if starting brood was more than tau days ago
        if(t > tau)
            H(t + 1) = H(t) + dt * dH(t);
        else
            H(t + 1) = H(t) + dt * dHs(t);
        end
        f(t + 1) = f(t) + dt * df(t);
              
    end
    
    
    % Plotting
    
    plot(B,'r.-');
    hold on
    plot(F,'g.-');
    hold on
    plot(H,'b.-');
    hold on
    plot(f,'k.-');
    hold on
    legend('Uncapped Brood','Forager Bees','Hive Bees','Stored Food')
    xlabel('days')
    ylabel('count / grams')
    
end