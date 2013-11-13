classdef Bee < handle
    properties
        prop;                     % Properties
        hive;                     % Hive the bee belongs to
        world;                    % The world the bee lives in
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
        % current food carrying
        food;
        % cluster size of this bee
        % This bee can carry the cluster size times the normal food of a
        % bee. One cluster bee stands for this amount of normal bees
        cluster_size;
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
        current_waypoint;        % Current waypoint for calculations
    end
    
    
    methods
        % Constructor
        function obj = Bee(hive, world, Prop)
            obj.prop = Prop;
            obj.world = world;
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
            obj.cluster_size = 0;
        end
        
        function work(obj, t_d, t_s, dt_s)
            switch obj.work_mode
                case 0
                    % Do nothing until job gets assigned
                case 1
                    % Scouting
                    if(obj.path.distance < obj.max_dist)
                        if(obj.time_counter >= obj.change_waypoint)
                            obj.time_counter = 0;
                            obj.path.append(obj.x_pos,obj.y_pos);
                            % Change in angle
                            obj.alpha = obj.alpha+obj.rotate_scale*randn();
                        end
                        % Last (rounded) position
                        y_min = ceil(obj.y_pos);
                        x_min = ceil(obj.x_pos);
                        % Random walk with border protection
                        obj.x_pos = min(max(obj.x_pos + cos(obj.alpha)*obj.speed*dt_s,0),obj.prop.Sim.world_size_10);
                        obj.y_pos = min(max(obj.y_pos + sin(obj.alpha)*obj.speed*dt_s,0),obj.prop.Sim.world_size_10);
                        obj.time_counter = obj.time_counter + dt_s;
                        % Current (rounded) position
                        y_max = ceil(obj.y_pos);
                        x_max = ceil(obj.x_pos);
                        % Get all points we passed on our way (bresenham line
                        % algorithm)
                        [y_points,x_points] = bresenham(x_min,y_min,x_max,y_max);
                        % Flower patch discovered. A patch is discovered when:
                        % - Quality is above zero (flowers are currently growing)
                        % - Typemap indicates that there is a flower patch
                        % - No other bee has marked this patch already
                        inds = sub2ind([obj.prop.Sim.world_size_10,obj.prop.Sim.world_size_10],y_points,x_points);
                        if(sum(obj.world.quality_map.array(inds)) > 0)
                            ind = inds(find(obj.world.quality_map.array(inds),1,'first'));
                            if(obj.world.type_map.array(ind) > 0 && ...
                                obj.world.type_map.array(ind) < 5 && ...
                                obj.hive.patches.array(ind) == 0)
                                % Mark the new patch, transition to new working
                                % state, report quality and size
                                [y,x] = ind2sub([obj.prop.Sim.world_size_10,obj.prop.Sim.world_size_10], ind);
                                [psize, pquality] = obj.mark_flower_patch(x,y);
                                obj.path.patch_size = psize;
                                obj.path.patch_quality = pquality;
                                % Last path point is the point where the flower
                                % patch has been discovered
                                obj.path.append(x,y);
                                obj.work_mode = 2;
                            end
                        end
                    else
                        % Scouting unsuccessful, return to hive
                        obj.work_mode = 2;
                    end
                        
                case 2
                    % TODO: Include wait time ('virtual time' to evaluate
                    % patch)
                    % Optimize path if probability says so
                    if(rand() <= obj.optimize_prob)
                        obj.path = obj.path.copy(1);
                    end
                    obj.current_waypoint = obj.path.length;
                    obj.work_mode = 3;
                case 3
                    % Fly back to hive
                    obj.move(-1,dt_s);
                    % Hive is reached, change work mode
                    if(obj.current_waypoint == 1)
                        obj.work_mode = 4;
                    end
                case 4
                    % TODO: Scout doing waggle dance
                    % Bee becomes unemployed again
                    obj.work_mode = 0;
                    obj.hive.scouts_count = obj.hive.scouts_count - 1;
                    obj.hive.bees_count = obj.hive.bees_count - 1;
                case 11
                case 12
                case 13
                case 14
                otherwise
            end
            obj.work_time = obj.work_time + dt_s;
        end
        
        % Mark a flower patch, report quality and size of the patch
        function [psize, pquality] = mark_flower_patch(obj, x, y)
            % Get flower patch that our scout bee discovered
            patch = bwselect(logical(obj.world.type_map.array),x,y);
            % Find nonzero fields, get indexes
            ind = find(patch);
            % Calculate patch size in 100m^2 units, 10^2m^2 per index
            psize = length(ind);
            % Calcualte average quality of the patch
            pquality = sum(obj.world.quality_map.array(ind))/psize*100;
            % Mark entire adjacent flower patch (segment, object)
            obj.hive.patches.array(ind) = 1;
        end
        
        function move(obj, direction, dt_s)
            % Calculate distance that can be passed in the calculation step
            % time (dt_s with speed)
            total_dist = obj.speed * dt_s;
            % As long as not all 'total_distance' is used & target not
            % reached
            while(total_dist > 0 && ...
                    ((direction == 1 && obj.current_waypoint < obj.path.length) || ...
                    ((direction == -1 && obj.current_waypoint > 1))))
                % Calculating distance from current position to the next
                % waypoint
                distance = norm([obj.x_pos;obj.y_pos] - obj.path.waypoints(:,obj.current_waypoint+direction),2);
                % Calculating remainder after reaching that point
                remainder_dist = total_dist - distance;
                if(remainder_dist > 0)
                    % Remainder is bigger than distance to next waypoint, we
                    % can go one further and loop
                    obj.current_waypoint = obj.current_waypoint + direction;
                    total_dist = remainder_dist;
                else
                    % Remainder not sufficient to reach the next waypoint,
                    % move closer to the next waypoint
                    factor = total_dist/distance;
                    obj.x_pos = obj.x_pos + factor * (obj.path.waypoints(1,obj.current_waypoint+direction) - obj.x_pos);
                    obj.y_pos = obj.y_pos + factor * (obj.path.waypoints(2,obj.current_waypoint+direction) - obj.y_pos);
                    total_dist = 0;
                end
            end
        end
    end
end