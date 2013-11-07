classdef Report < handle
    % Collects data
    
    properties
        data
        prop
    end
    
    methods
        % Constructor
        function obj = Report(Prop)
            obj.prop = Prop;
        end
        
        % Save to file
        function save(obj)
            save(strcat('\results\',obj.prop.Sys.identifier,'_report','-mat'), obj.data);
        end
        
    end
    
end

