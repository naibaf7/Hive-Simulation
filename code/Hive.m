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
        
        extinct_barrier;         % Min. bees required for the hive to survive
        is_extinct;              % Hive extinct or not
        
        % For realtime environment simulation
        daily_activity;          % Activity during the day
        
        x_pos;                   % X-position in the world
        y_pos;                   % Y-position in the world
        
        foragers;                % Array of forager bees
        scouts;                  % Array of scout bees
        
        waggle_paths;            % Available waggles to copy
        waggle_data;             % Array for fast waggle evaluation
        waggle_count;            % Current waggle count
        
        scouts_count;            % Current scout count
        max_scout_percent;       % Max. percent of active bees that are scouts
        bees_count;              % Current active bees
        
        max_forager_clusters;    % Amount of forager bees that can be simulated in total (clustering)
        cluster_size             % Size of a bee cluster
        
        beemap;                  % Rasterized map of bees (N/10xN/10, where N is the world size)
        patches;                 % Map of already discovered flower patches
        
        % We add a barrier to stop scouting bees as soon as all patches
        % have been discovered, which is not something bees would do. But
        % we can do it here as the scout bees don't have any effect after
        % they found every patch, but it's computationally very expensive
        % to keep them in the random walk algorithm.
        patches_total;           % Total patches
        patches_discovered;      % Discovered patches
        
        daily_food_sum;          % Aggregated collected food per day
        fixed_food_rate;         % Fixed rate (original model) or advanced model
        
    end
    
    methods
        % Constructor
        function obj = Hive(hive_index, world, Prop)
            obj.prop = Prop;
            
            obj.hive_ind = hive_index;
            
            obj.world = world;
            obj.x_pos = Prop.Sim.Hive(obj.hive_ind).x_pos;
            obj.y_pos = Prop.Sim.Hive(obj.hive_ind).y_pos;
            
            obj.is_extinct = 0;

            obj.fixed_food_rate = Prop.Sim.Hive(obj.hive_ind).fixed_food_rate;
            obj.max_sim_time = Prop.Sim.eval_time_days;

            obj.B = zeros(1,obj.max_sim_time);
            obj.H = zeros(1,obj.max_sim_time);
            obj.f = zeros(1,obj.max_sim_time);
            obj.F = zeros(1,obj.max_sim_time);
            
            obj.daily_food_sum = zeros(1,obj.max_sim_time);

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
            
            obj.extinct_barrier = Prop.Sim.Hive(obj.hive_ind).extinct_barrier;
            obj.max_scout_percent = Prop.Sim.Hive(obj.hive_ind).scout_count;
            
            obj.max_forager_clusters = Prop.Sim.Hive(obj.hive_ind).max_forager_clusters;
            obj.cluster_size = 1;
            
            obj.scouts = Bee.empty(round(obj.F(1)*obj.max_scout_percent), 0);
            
            obj.foragers = Bee.empty(obj.max_forager_clusters, 0);

            % Instantiate bees
            for i=1:round(obj.F(1)*obj.max_scout_percent)
                obj.scouts(i) = Bee(obj, obj.world, obj.prop);
            end
            
            for i=1:obj.max_forager_clusters
                obj.foragers(i) = Bee(obj, obj.world, obj.prop);
            end

            % Interpolate daily activity
            daily_activity_x = Prop.Sim.Hive(obj.hive_ind).daily_activity(1,:);
            daily_activity_y = Prop.Sim.Hive(obj.hive_ind).daily_activity(2,:);
            obj.daily_activity = interpolate_values(daily_activity_x, daily_activity_y,1,1,12,0,1);
            
            % Initialize empty beemap
            obj.beemap = Map(0,obj.prop.Sim.world_size_10,obj.prop.Sim.world_size_10);
            
            % Initialize patches map
            obj.patches = Map(0,obj.prop.Sim.world_size_10,obj.prop.Sim.world_size_10);

            % Brood survival rate
            obj.S = @(H, f) f^2/(f^2 + obj.b^2) * H/(H+obj.v);

            % Recruitment function
            obj.R = @(H, F, f) obj.amin + obj.amax*(obj.b^2/(obj.b^2+f^2)) - obj.sigma * (F/(F+H));
        end
        
        % Count active patches
        function count = count_patches(obj)
            % Maps to logic maps conversion
            logic_quality_map = logical(obj.world.quality_map.array);
            logic_type_map = logical(obj.world.type_map.array);
            logic_map = logic_quality_map & logic_type_map;
            [sm,sn] = size(logic_map);
            check_map = zeros(sm,sn);
            count = 0;
            % Go through map
            for y = 1:sm
                for x = 1:sn
                    % Check map to avoid double counting
                    if(check_map(y,x) == 0 && logic_map(y,x) == 1)
                        patch = bwselect(logic_map,x,y);
                        ind = find(patch);
                        check_map(ind) = 1;
                        count = count + 1;
                    end
                end
            end
        end
        
        % Compare own food source against all other food sources
        function prob = food_source_compare(obj, path)
            if(obj.waggle_count > 0)
                % Calculating relative probability compared to other
                % patches
                prob = path.patch_quality/(sum(obj.waggle_data(1:obj.waggle_count,2))/obj.waggle_count) * ...
                    path.patch_size/(sum(obj.waggle_data(1:obj.waggle_count,3))/obj.waggle_count) * ...
                    path.distance/(sum(obj.waggle_data(1:obj.waggle_count,4))/obj.waggle_count);
            else
                % It's the first waggle we test against, so it's the best
                prob = 1;
            end
        end
        
        % Register a waggle dance after arriving at the hive
        function register_waggle_dance(obj, path, prob)
            obj.waggle_count = obj.waggle_count + 1;
            % Enter path
            obj.waggle_paths(obj.waggle_count) = path;
            % Enter data in separate array (for speed)
            obj.waggle_data(obj.waggle_count, :) = [prob, path.patch_quality, path.patch_size, path.distance];
            % Normalize probabilities of accepting a waggle dance
            if(prob > 1)
                obj.waggle_data(1:obj.waggle_count,1) = obj.waggle_data(1:obj.waggle_count,1)/prob;
            end
        end
        
        % Mark a flower patch, report quality and size of the patch
        function [psize, pquality, ptype] = mark_flower_patch(obj, x, y)
            % Get flower patch that our scout bee discovered
            patch = bwselect(logical(obj.world.type_map.array),x,y);
            % Find nonzero fields, get indexes
            ind = find(patch);
            % Calculate patch size in 100m^2 units, 10^2m^2 per index
            psize = length(ind);
            % Calcualte average quality of the patch
            pquality = sum(obj.world.quality_map.array(ind))/psize;
            % Get flower type
            ptype = obj.world.type_map.array(y,x);
            % Mark entire adjacent flower patch (segment, object)
            obj.patches.array(ind) = 1;
            % Add flower patch to counting variable
            obj.patches_discovered = obj.patches_discovered + 1;
        end
        
        % Watch a waggle dance and maybe use it
        function [got_path, path] = watch_waggle(obj)
            path = 0;
            % Select one, randomly
            if(obj.waggle_count > 0)
                i = randi([1,obj.waggle_count],1);
                % Bee decided that the patch is good enough
                if(rand() < obj.waggle_data(i,1))
                    got_path = 1;
                    path = obj.waggle_paths(i);
                else
                    got_path = 0;
                end
            else
                got_path = 0;
            end
        end
        
        
        % Iterative daily simulation step
        function simulate_s(obj, t_s, t_d, dt_s)
            obj.waggle_count = 0;
%             for i = 1:round(obj.F(t_d)*obj.max_scout_percent)
%                 % Don't record bees that don't work
%                 if(obj.scouts(i).work_mode ~= 0)
%                     % Add bee record at current position
%                     x = ceil(obj.scouts(i).x_pos);
%                     y = ceil(obj.scouts(i).y_pos);
%                     obj.beemap.array(y,x) = obj.beemap.array(y,x) - 1;
%                 end
%             end
%             for i = 1:obj.max_forager_clusters
%                 % Don't record bees that don't work
%                 if(obj.foragers(i).work_mode ~= 0)
%                     % Add bee record at current position
%                     x = ceil(obj.foragers(i).x_pos);
%                     y = ceil(obj.foragers(i).y_pos);
%                     obj.beemap.array(y,x) = obj.beemap.array(y,x) - obj.cluster_size;
%                 end
%             end
            
            % Scouts working loop
            for i = 1:round(obj.F(t_d)*obj.max_scout_percent)
                % Assign jobs to scouts
                if(obj.scouts(i).work_mode == 0)
                     % More active bees possible?
                     if(obj.bees_count < obj.F(t_d)*obj.daily_activity(ceil(t_s/3600)))
                        % More scouts possible?
                        if(obj.scouts_count < obj.F(t_d)*obj.daily_activity(ceil(t_s/3600))*obj.max_scout_percent)
                            obj.scouts_count = obj.scouts_count + 1;
                            obj.bees_count = obj.bees_count + 1;
                            % Assign scout job
                            obj.scouts(i).work_mode = 1;
                            obj.scouts(i).path = Path();
                            % Starting point in the hive
                            obj.scouts(i).path.append(obj.x_pos,obj.y_pos);
                            % Random starting direction from the hive
                            obj.scouts(i).alpha = rand()*2*pi;
                        end
                     end
                end
                obj.scouts(i).work(t_d, t_s, dt_s);
            end
            
            % Foragers working loop
            for i = 1:obj.max_forager_clusters
                % Assign jobs to scouts
                if(obj.foragers(i).work_mode == 0)
                     % More active bees possible?
                     if(obj.bees_count < obj.F(t_d)*obj.daily_activity(ceil(t_s/3600)))
                        obj.foragers(i).work_mode = 11;
                     end
                else
                    obj.foragers(i).work(t_d, t_s, dt_s);
                end
            end
            
%             for i = 1:round(obj.F(t_d)*obj.max_scout_percent)
%                 % Don't record bees that don't work
%                 if(obj.scouts(i).work_mode ~= 0)
%                     % Add bee record at current position
%                     x = ceil(obj.scouts(i).x_pos);
%                     y = ceil(obj.scouts(i).y_pos);
%                     obj.beemap.array(y,x) = obj.beemap.array(y,x) + 1;
%                 end
%             end
%             for i = 1:obj.max_forager_clusters
%                 % Don't record bees that don't work
%                 if(obj.foragers(i).work_mode ~= 0)
%                     % Add bee record at current position
%                     x = ceil(obj.foragers(i).x_pos);
%                     y = ceil(obj.foragers(i).y_pos);
%                     obj.beemap.array(y,x) = obj.beemap.array(y,x) + obj.cluster_size;
%                 end
%             end
        end
        
        % Reset daily simulation parameters
        function reset_s(obj, t_d)
            % Reset bees
            for i=1:obj.max_forager_clusters
                obj.foragers(i).work_mode = 0;
                obj.foragers(i).work_time = 0;
                obj.foragers(i).food = 0;
                obj.foragers(i).time_counter = 0;
                obj.foragers(i).x_pos = obj.x_pos;
                obj.foragers(i).y_pos = obj.y_pos;
            end
            for i=1:round(obj.F(t_d)*obj.max_scout_percent)
                obj.scouts(i).work_mode = 0;
                obj.scouts(i).work_time = 0;
                obj.scouts(i).food = 0;
                obj.scouts(i).time_counter = 0;
                obj.scouts(i).x_pos = obj.x_pos;
                obj.scouts(i).y_pos = obj.y_pos;
            end
            % Reset hive
            obj.cluster_size = round(obj.F(t_d)/obj.max_forager_clusters);
            obj.bees_count = 0;
            obj.scouts_count = 0;
            obj.daily_food_sum(t_d) = 0;
            % Allocate enough space for waggle dances
            obj.waggle_paths = Path.empty(round(obj.F(t_d)*obj.max_scout_percent) + obj.max_forager_clusters,0);
            obj.waggle_data = zeros(round(obj.F(t_d)*obj.max_scout_percent) + obj.max_forager_clusters,4);
            % Count total patches, discovered patches = 0
            obj.patches_total = obj.count_patches();
            obj.patches_discovered = 0;
        end
        
        % Iterative simulation step
        function simulate_d(obj, t_d)
            if(~obj.is_extinct)
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
                if(obj.fixed_food_rate == 1)
                    % Fixed rate mode from original model
                    df = @(t) obj.c * obj.F(t) - obj.coFH * (obj.F(t) + obj.H(t)) - obj.coB * obj.B(t);
                else
                    % Environment dependent mode from advanced model
                    df = @(t) obj.daily_food_sum(t) - obj.coFH * (obj.F(t) + obj.H(t)) - obj.coB * obj.B(t);
                end

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
                if(length(obj.scouts) < round(obj.F(t_d+1)*obj.max_scout_percent))
                    new_scouts = Bee.empty(round(obj.F(t_d+1)), 0);
                    new_scouts(1:length(obj.scouts)) = obj.scouts(:);
                    for i=length(obj.scouts)+1:round(obj.F(t_d+1))
                        new_scouts(i) = Bee(obj, obj.world, obj.prop);
                    end
                    obj.scouts = new_scouts;
                end
                
                % Hive extinct due to a too low bee count that cannot run a hive
                if(obj.B(t_d+1)+obj.F(t_d+1) < obj.extinct_barrier)
                    obj.is_extinct = 1;
                end
            else
                % Hive extinct. No bees in the hive
                obj.B(t_d + 1) = 0;
                obj.F(t_d + 1) = 0;
                obj.H(t_d + 1) = 0;
                % Food does not change anymore
                obj.f(t_d + 1) = obj.f(t_d);
            end
        end
        
        function draw_s(obj)
            clf
            colormap('hot')
            %subplot(1,2,1);
            %imagesc(obj.patches.array);
            %subplot(1,2,2);
            imagesc(logical(obj.beemap.array));
            colorbar
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