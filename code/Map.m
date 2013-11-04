classdef Map < handle
   
    properties
        array
    end
    
    methods
        % Constructor
        function obj = Map(is_sparse, m, n)
            if(is_sparse)
                obj.array = sparse(m, n);
            else
                obj.array = zeros(m, n);
            end
        end
    end
    
end

