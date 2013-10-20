classdef World < handle

    properties
        prop;
        % base land property map, dimensions 1 x (N/10) x (N/10)
        % dense and handle
        land_map
        % map with scent distribution, dimensions 2 x N x N
        % sparse and handle
        scent_map_l         % last version
        scent_map_c         % current version
        % map with flowers, dimensions 2 x N x N
        % sparse and handle
        flower_map
    end
    
    methods
        % Constructor
        function obj = World(Prop)
            obj.prop = Prop;
            
        end
        
        % Iterative simulation step
        function simulate(obj, t_d)
            
            
        end
        
    end


end

