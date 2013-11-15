classdef Report < handle
    % Collects data
    
    properties
        data
        prop
    end
    
    methods
        
        % Constructor
        function obj = Report(prop)
            obj.prop = prop;
        end
        
        % Save to file
        function save(obj)
            obj.prop.Sys.identifier
            save(strcat(pwd,'\results\',obj.prop.Sys.identifier,'_report.mat'), 'obj','-mat');
        end
        
    end
    
end

