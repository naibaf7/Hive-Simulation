classdef Bee < handle
    properties
        prop                     % Properties
        hive                     % Hive the bee belongs to
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
        work_mode
        % work time, time spent in current work state
        work_time
        x_pos                   % X-position in the world
        y_pos                   % Y-position in the world
        path                    % Flying path (waypoints)
    end
    
    
    methods
        % Constructor
        function obj = Bee(hive, Prop)
            obj.prop = Prop;
            obj.hive = hive;
            obj.x_pos = hive.x_pos;
            obj.y_pos = hive.y_pos;
        end
        
        function work(obj)
            switch obj.work_mode
                case 0
                    % Do nothing until job gets assigned
                case 1
                    
                case 2
                case 3
                case 4
                case 11
                case 12
                case 13
                case 14
                otherwise
            end
        end
        
        
        function move(obj, dt_s)
            
        end
    end
end