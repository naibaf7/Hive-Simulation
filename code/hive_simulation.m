function hive_simulation()

    fprintf('#################### HIVE-SIMULATION ####################\n');

    % Ask user to input a properties file for the simulation
    [file_name, path_name] = uigetfile('*.m','Select simulation property file');
    
    fprintf('Loading properties...\n');
    
    % Construct absolute loading path
    load_properties = strcat(path_name,file_name);
    
    % Load properties
    run(load_properties);
    
    % Initialize thread pool
    fprintf('Initializing thread pool...\n');
    threads = matlabpool('size');
    cores = feature('numCores');
    if((threads ~= min(cores, Prop.Sys.cores)) && threads > 0)
        if threads > 0
            matlabpool('close');
        end
        matlabpool('open', min(cores, Prop.Sys.cores));
    end
    
    % Initialize world
    fprintf('Initializing world...\n');
    % TODO
    
    % Initialize hives
    fprintf('Initializing hives...\n');
    hives = Hive.empty(Prop.Sim.hive_count, 0);
    for i = 1:Prop.Sim.hive_count
        hives(i) = Hive(i, Prop);
    end
    
    % Start simulation
    fprintf('Starting simulation (%d days)...\n', Prop.Sim.eval_time_days);
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
    fprintf('Simulation finished.\n');
    fprintf('#########################################################\n');
end