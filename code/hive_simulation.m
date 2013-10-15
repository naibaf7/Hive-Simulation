function hive_simulation()

    % Ask user to input a properties file for the simulation
    [file_name, path_name] = uigetfile('*.m','Select simulation property file');
    
    % Construct absolute loading path
    load_properties = strcat(path_name,file_name);
    
    % Load properties
    run(load_properties);
    
    % Initialize thread pool
    % From: 
    threads = matlabpool('size');
    cores = feature('numCores');
    if((threads ~= min(cores, Prop.Sys.Cores)) && threads > 0)
        if threads > 0
            matlabpool('close');
        end
        matlabpool('open', min(cores, Prop.Sys.Cores));
    end
    
    % Initialize hives
    hives = Hive.empty(Prop.Sim.hive_count, 0);
    for i = 1:Prop.Sim.hive_count
        hives(i) = Hive(i, Prop);
    end
    
    % Start simulation
    
    for t_d = 1:Prop.Sim.eval_time_days;
        % Re-evaluate environment
        if(mod(t_d-1,Prop.Sim.eval_step_days) == 0)
            for t_s = 1:Prop.Sim.eval_time_seconds
                % TODO: Realtime environment evaluation
            end
        end
        
        % TODO: Daily environment evaluation (flower patches etc.)
        parfor i = 1:Prop.Sim.hive_count
            hives(i).simulate(t_d);
        end
        
        % TODO: Update graphics
    end
    
    % TEMP:
    hives(1).plot();
    
    
    
    % TODO: Write data to files
    

end