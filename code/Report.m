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
            save(obj.data, strcat('results\',obj.prop.identifier,'_report.m'));
        end
        
    end
    
end

