classdef Hive < handle
   
    properties
        prop;                    % Properties
        hive_ind;                % Hive index in the world
        max_sim_time;            % Simulation length
        B;                       % Uncapped brood
        H;                       % Hive bees
        f;                       % Food storage
        F;                       % Foragers
        b;                       % Food effect on brood survival
        v;                       % Hive bees effect on brood survival
        tau;                     % Aging time in days (12 days [2])
        amin;                    % Minimum recruitment
        amax;                    % Food dependent recruitment
        L;                       % Laying rate of the queen
        L_year;                  % Laying rate change over the year
        m;                       % Forager death rate
        sigma;                   % Social inhibition strength
        phi;                     % Adult bee emerging factor
        c;                       % Food per forager and day, will vary with advanced model!
        coFH;                    % Food consumption of adult bees (g)
        coB;                     % Food consumption of brood (g)
        
        S;                       % Brood survival rate
        R;                       % Recruitment function
        
        % For realtime environment simulation
        x_pos;                   % X-position in the world
        y_pos;                   % Y-position in the world
        
        bees;                    % Array of bees
        waggels;                 % Available waggles to copy
        
    end
    
    methods
        % Constructor
        function obj = Hive(hive_index, Prop)
            if(nargin == 0)
                % No arguments passed, load default settings

                obj.prop = Prop;
                
                obj.hive_ind = 1;
                
                obj.max_sim_time = 365;             % One year
                
                obj.B = zeros(1,obj.max_sim_time);
                obj.H = zeros(1,obj.max_sim_time);
                obj.f = zeros(1,obj.max_sim_time);
                obj.F = zeros(1,obj.max_sim_time);
                
                obj.B(1) = 0;
                obj.H(1) = 16000;
                obj.f(1) = 0;
                obj.F(1) = 8000;

                obj.b = 500;
                obj.v = 5000;
                obj.tau = 12;
                obj.amin = 0.25;
                obj.amax = 0.25;
                obj.L = 2000;
                obj.L_year = @(x) 1;
                obj.m = 0.3;
                obj.sigma = 0.75;
                obj.phi = 1/9;
                obj.c = 0.1;

                obj.coFH = 0.007;
                obj.coB = 0.018;  
            else
            	% Load settings from properties
                obj.hive_ind = hive_index;
                
                obj.max_sim_time = Prop.Sim.eval_time_days;
                
                obj.B = zeros(1,obj.max_sim_time);
                obj.H = zeros(1,obj.max_sim_time);
                obj.f = zeros(1,obj.max_sim_time);
                obj.F = zeros(1,obj.max_sim_time);
                
                obj.B(1) = Prop.Sim.Hive(obj.hive_ind).uncapped_brood;
                obj.H(1) = Prop.Sim.Hive(obj.hive_ind).hive_bees;
                obj.f(1) = Prop.Sim.Hive(obj.hive_ind).food;
                obj.F(1) = Prop.Sim.Hive(obj.hive_ind).foragers;

                obj.b = Prop.Sim.Hive(obj.hive_ind).food_brood_eff;
                obj.v = Prop.Sim.Hive(obj.hive_ind).hive_brood_eff;
                obj.tau = Prop.Sim.Hive(obj.hive_ind).aging_time;
                obj.amin = Prop.Sim.Hive(obj.hive_ind).min_recruitment;
                obj.amax = Prop.Sim.Hive(obj.hive_ind).max_recruitment;
                obj.L = Prop.Sim.Hive(obj.hive_ind).laying_rate;
                
                % Load x values of measure points for laying rate change
                L_year_x = Prop.Sim.Hive(obj.hive_ind).laying_function(1,:);
                % Load y values of measure points for laying rate change
                L_year_y = Prop.Sim.Hive(obj.hive_ind).laying_function(2,:);
                % Interpolate values of laying rate change for 365 days
                obj.L_year = interpolate_values(L_year_x,L_year_y,1,1,365,0,1);
                
                obj.m = Prop.Sim.Hive(obj.hive_ind).mortality;
                obj.sigma = Prop.Sim.Hive(obj.hive_ind).social_inhibition;
                obj.phi = Prop.Sim.Hive(obj.hive_ind).adult_bee_emerging;
                obj.c = Prop.Sim.Hive(obj.hive_ind).food_per_forager;

                obj.coFH = Prop.Sim.Hive(obj.hive_ind).food_consumption_adult;
                obj.coB = Prop.Sim.Hive(obj.hive_ind).food_consumption_brood;
                
                obj.bees = Bee.empty(Obj.F(1), 0);
                for i=1:Obj.F(1)
                    
                end
                
            end
            
                obj.S = @(H, f) f^2/(f^2 + obj.b^2) * H/(H+obj.v);
                
                obj.R = @(H, F, f) obj.amin + obj.amax*(obj.b^2/(obj.b^2+f^2)) - obj.sigma * (F/(F+H));
        end
        
        
        function simulate_s(obj, t_s)
            
        end
        
        % Iterative simulation step
        function simulate_d(obj, t_d)
            % Function handles
            
            % Brood change rate
            dB = @(t) obj.L_year(mod(t_d - 1, 365) + 1) * obj.L * obj.S(obj.H(t), obj.f(t)) - obj.phi * obj.B(t);
            
            % Rate of change of hive bees > tau
            dH = @(t) obj.phi * obj.B(t - obj.tau) - obj.H(t) * obj.R(obj.H(t), obj.F(t), obj.f(t));
            
            % Rate of change of hive bees <= tau
            dHs = @(t) - obj.H(t) * obj.R(obj.H(t), obj.F(t), obj.f(t));
            
            % Rate of change of foragers
            dF = @(t) obj.H(t) * obj.R(obj.H(t), obj.F(t), obj.f(t)) - obj.m*obj.F(t);
            
            % Food change rate
            df = @(t) obj.c * obj.F(t) - obj.coFH * (obj.F(t) + obj.H(t)) - obj.coB * obj.B(t);

            % Calculate t+1
            obj.B(t_d + 1) = max(obj.B(t_d) + dB(t_d), 0);
            obj.F(t_d + 1) = max(obj.F(t_d) + dF(t_d), 0);
            
            % Hive bees can only emerge if starting brood was more than tau days ago
            if(t_d > obj.tau)
                obj.H(t_d + 1) = max(obj.H(t_d) + dH(t_d), 0);
            else
                obj.H(t_d + 1) = max(obj.H(t_d) + dHs(t_d), 0);
            end
            obj.f(t_d + 1) = max(obj.f(t_d) + df(t_d), 0);
        end
        
        function plot(obj)
            subplot(2,1,1);
            plot(obj.B,'r-','LineWidth', 2);
            hold on
            plot(obj.F,'g-','LineWidth', 2);
            hold on
            plot(obj.H,'b-','LineWidth', 2);
            hold on
            legend('Uncapped Brood','Forager Bees','Hive Bees')
            xlabel('days')
            ylabel('count')
            subplot(2,1,2);
            plot(obj.f,'k-','LineWidth', 2);
            hold on
            legend('Stored Food')
            xlabel('days')
            ylabel('grams')
        end
    end
end