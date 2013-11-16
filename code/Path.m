classdef Path < handle
    
    properties
        waypoints               % 2 x n matrix
        patch_size              % Patch size (m^2)
        patch_quality           % Average patch quality (normalized percents)
        patch_type              % Flower type of the patch
        length                  % Save length of path explicitly
        distance                % Compute and save distance
    end
    
    methods
        % Constructor
        function obj = Path()
            obj.length = 0;
            obj.distance = 0;
            obj.patch_quality = 0;
            obj.patch_size = 0;
            obj.patch_type = 0;
        end
        
        % Copy the path to a new path and copy properties, probably with
        % optimization, leave old path untouched
        function new_obj = copy(obj, optimize)
            [~, old_n] = size(obj.waypoints);
            % skip every second waypoint to shorten the path
            if((optimize == 1) && (obj.length ~= 2))
                new_obj = Path();
                new_obj.patch_size = obj.patch_size;
                new_obj.patch_quality = obj.patch_quality;
                new_obj.patch_type = obj.patch_type;
                new_n = floor((old_n-2)/2)+2;
                new_obj.waypoints = zeros(2,new_n);
                % copy every 2nd waypoint, preserve start and end point
                inserts = obj.waypoints(:,1:2:old_n);
                [~,ins_size] = size(inserts);
                new_obj.waypoints(:,1:1:ins_size) = inserts;
                new_obj.waypoints(:,new_n) = obj.waypoints(:,old_n);
                new_obj.length = new_n;
                new_obj.distance = 0;
                for i = 2:new_obj.length
                    new_obj.distance = new_obj.distance + norm(new_obj.waypoints(:,i-1)-new_obj.waypoints(:,i),2);
                end
            else
                new_obj = obj;
            end
        end
        
        % Append a waypoint to the path
        function append(obj, x, y)
            [~, old_n] = size(obj.waypoints);
            obj.waypoints(:,old_n+1) = [x; y];
            obj.length = obj.length + 1;
            if(obj.length == 1)
                obj.distance = 0;
            else
                obj.distance = obj.distance + norm(obj.waypoints(:,obj.length-1)-obj.waypoints(:,obj.length),2);
            end
        end
        
        
    end
    
end

