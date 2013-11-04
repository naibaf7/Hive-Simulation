classdef Hive < handle
   
    properties
        prop;                    % Properties
        hive_ind;                % Hive index in the world
        world;                   % Handle on the world
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
        
        beemap;                  % Rasterized map of bees (N/10xN/10, where N is the world size)
        
    end
    
    methods
        % Constructor
        function obj = Hive(hive_index, world, Prop)
            obj.prop = Prop;
            
            obj.hive_ind = hive_index;
            
            obj.world = world;

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

            obj.bees = Bee.empty(obj.F(1), 0);

            for i=1:obj.F(1)
                obj.bees(i) = Bee(obj, obj.prop);
            end

            % Initialize empty beemap
            obj.prop.Sim.world_size
            obj.beemap = Map(0,obj.prop.Sim.world_size/10,obj.prop.Sim.world_size/10);

            % Brood survival rate
            obj.S = @(H, f) f^2/(f^2 + obj.b^2) * H/(H+obj.v);

            % Recruitment function
            obj.R = @(H, F, f) obj.amin + obj.amax*(obj.b^2/(obj.b^2+f^2)) - obj.sigma * (F/(F+H));
        end
        
        % Iterative daily simulation step
        function simulate_s(obj, t_s, t_d, dt_supdate)
            % After defined update step size, reset bee map
            if(mod(t_s - 1, dt_supdate) == 0)
                obj.beemap.array = zeros(obj.prop.Sim.world_size/10, obj.prop.Sim.world_size/10);
            end
            for i = 1:round(obj.F(t_d));
                % Let the bees work
                obj.bees(i).work();
                % Update rasterized bee map
                if(mod(t_s - 1, dt_supdate) == 0)
                    x = ceil(obj.bees(i).x_pos/10);
                    y = ceil(obj.bees(i).y_pos/10);
                    obj.beemap.array(y,x) = obj.beemap.array(y,x) + 1;
                end
            end
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
             
            % Check if enough bees instantiated, increase if needed
            if(length(obj.bees) < round(obj.F(t_d)))
                new_bees = Bee.empty(round(obj.F(t_d)), 0);
                new_bees(1:length(obj.bees)) = obj.bees(:);
                for i=length(obj.bees)+1:round(obj.F(t_d))
                    new_bees(i) = Bee(obj, obj.prop);
                end
                obj.bees = new_bees;
            end
            obj.F(t_d)
            length(obj.bees)
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