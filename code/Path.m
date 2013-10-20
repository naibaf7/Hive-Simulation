classdef Path < handle
    
    properties
        waypoints               % 2 x n matrix
    end
    
    methods
        % Constructor
        function obj = Path()
        end
        
        % Copy the path to a new new_object
        function new_obj = copy(obj, optimize)
            new_obj = Path();
            [~, old_n] = size(obj.waypoints);
            % skip every second waypoint to shorten the path
            if(optimize)
                new_n = floor((old_n-2)/2)+2;
                new_obj.waypoints = zeros(2,new_n);
                % copy every 2nd waypoint, preserve start and end point
                inserts = obj.waypoints(:,1:2:old_n);
                [~,ins_size] = size(inserts);
                new_obj.waypoints(:,1:1:ins_size) = inserts;
                new_obj.waypoints(:,new_n) = obj.waypoints(:,old_n);
            else
                new_obj.waypoints = obj.waypoints;
            end
        end
        
        % Append a waypoint to the path
        function append(obj, x, y)
            [~, old_n] = size(obj.waypoints);
            obj.waypoints(:,old_n+1) = [x; y];
        end
    end
    
end

