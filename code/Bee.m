classdef Bee < handle
    properties
        prop;                     % Properties
        hive;                     % Hive the bee belongs to
        % Current work mode
        % 0: no job
        % 1: scout, searching flower patch
        % 2: scout, evaluating flower patch
        % 3: scout, returning to hive
        % 4: scout, waggle dance
        % 11: forager, going to food source
        % 12: forager, collecting food at source
        % 13: forager, going to adjacent flowers
        % 14: forager, way back home
        % 15: forager, food dispatch
        % 16: forager, waggle dance
        work_mode;
        % work time, time spent in current work state
        work_time;
        % time stepping counter
        time_counter;
        x_pos;                   % X-position in the world
        y_pos;                   % Y-position in the world
        alpha;                   % Flight direction angle
        path;                    % Flying path (waypoints)
        speed;                   % Flying speed
        max_food;                % Max. food carry capacity
        rotate_scale;            % Angle scale for scouting
        max_dist;                % Max. flight distance
        optimize_prob;           % Path optimization probability
        change_waypoint;         % Time after which to set a new waypoint (s)
    end
    
    
    methods
        % Constructor
        function obj = Bee(hive, Prop)
            obj.prop = Prop;
            obj.hive = hive;
            obj.x_pos = hive.x_pos;
            obj.y_pos = hive.y_pos;
            obj.work_mode = 0;
            obj.work_time = 0;
            obj.time_counter = 0;
            obj.speed = Prop.Sim.Hive(obj.hive.hive_ind).Bee.flight_speed;
            obj.max_food = Prop.Sim.Hive(obj.hive.hive_ind).Bee.max_food;
            obj.max_dist = Prop.Sim.Hive(obj.hive.hive_ind).Bee.max_dist;
            obj.rotate_scale = Prop.Sim.Hive(obj.hive.hive_ind).Bee.rotate_scale;
            obj.optimize_prob = Prop.Sim.Hive(obj.hive.hive_ind).Bee.optimize_prob;
            obj.change_waypoint = Prop.Sim.Hive(obj.hive.hive_ind).Bee.change_waypoint;
        end
        
        function work(obj, t_d, t_s, dt_s)
            switch obj.work_mode
                case 0
                    % Do nothing until job gets assigned
                case 1
                    % Scouting
                    if(obj.time_counter >= obj.change_waypoint)
                        obj.time_counter = 0;
                        obj.path.append(obj.x_pos,obj.y_pos);
                        % Change in angle
                        obj.alpha = obj.alpha+obj.rotate_scale*randn();
                    end
                    % Random walk
                    obj.x_pos = obj.x_pos + cos(obj.alpha)*v;
                    obj.y_pos = obj.y_pos + sin(obj.alpha)*v;
                    obj.time_counter = obj.time_counter + dt_s;
                case 2
                case 3
                case 4
                case 11
                case 12
                case 13
                case 14
                otherwise
            end
            obj.work_time = obj.work_time + dt_s;
        end
        
        
        function move(obj, dt_s)
            
        end
    end
end