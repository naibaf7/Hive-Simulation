classdef Map
   
    properties
        array
    end
    
    methods
        % Constructor
        function obj = Map(sparse, size)
            obj.array = sparse(size);
        end
    end
    
end

