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
    
    % Initialize report
    fprintf('Initializing report...\n');
    report = Report(Prop);
    
    % Initialize world
    fprintf('Initializing world...\n');
    world = World(Prop);
    
    % Initialize hives
    fprintf('Initializing hives...\n');
    hives = Hive.empty(Prop.Sim.hive_count, 0);
    for i = 1:Prop.Sim.hive_count
        hives(i) = Hive(i, world, Prop);
    end
    
    figure
    
    % Start simulation
    fprintf('Starting simulation (%d days)...\n', Prop.Sim.eval_time_days);
    
    reversestr_a = '';
    reversestr_b = '';
    percent_A_old = -1;
    percent_B_old = -1;
    for t_d = 1:Prop.Sim.eval_time_days
        % Re-evaluate environment if there is any need for it
        % The need is defined by checking if some flower is active at the
        % moment.
        activity_sum = sum(sum(world.quality_map.array));
        
        % Check for extinct hives and hives with constant food rate
        dont_calculate_sum = 0;
        for i = 1:Prop.Sim.hive_count
            if(hives(i).fixed_food_rate || hives(i).is_extinct)
                dont_calculate_sum = dont_calculate_sum + 1;
            end
        end
        
        % There is activity, 
        if(activity_sum > 0 && dont_calculate_sum ~= Prop.Sim.hive_count)
            dt_s = Prop.Sim.eval_step_seconds;
            for i = 1:Prop.Sim.hive_count
                % Reset environment simulation for new day
                hives(i).reset_s(t_d);
            end
            for t_s = 1:Prop.Sim.eval_time_seconds
                if(mod(t_s-1,dt_s)==0)
                    for i = 1:Prop.Sim.hive_count
                        if(~hives(i).is_extinct && hives(i).fixed_food_rate == 0)
                            hives(i).simulate_s(t_s, t_d, dt_s);
                        end
                    end
                end
                % TODO: COMMENT OUT AGAIN
                if(mod(t_s,240)==0)
                    hives(1).draw_s();
                    %world.draw_s();
                    pause(0.0001);
                    %t_s
                end
                % Print progress
                percent_B = ceil(t_s/Prop.Sim.eval_time_seconds*50);
                if(percent_B ~= percent_B_old)
                    progstr_b = '';
                    for j=1:percent_B
                        progstr_b = strcat(progstr_b,'#');
                    end
                    for j=percent_B:49
                        progstr_b = strcat(progstr_b,'.');
                    end
                    msg_b = sprintf(strcat('Progress (environment): [',progstr_b,']\n'), t_s, Prop.Sim.eval_time_seconds);
                    fprintf([reversestr_b, msg_b]);
                    reversestr_b = repmat(sprintf('\b'), 1, length(msg_b));
                    percent_B_old = percent_B;
                end
            end
        else
           for i = 1:Prop.Sim.hive_count
               % Daily food income (aggregated) is zero if no flower
               % activity
               hives(i).daily_food_sum(t_d) = 0;
           end
        end
        
        % Daily environment simulation
        world.simulate_d(t_d);
        % Daily hive simulation
        for i = 1:Prop.Sim.hive_count
            hives(i).simulate_d(t_d);
        end
        
        %world.draw_d();
        
        % Print progress
        percent_A = ceil(t_d/Prop.Sim.eval_time_days*50);
        if(percent_A ~= percent_A_old)
            progstr_a = '';
            for j=1:percent_A
                progstr_a = strcat(progstr_a,'#');
            end
            for j=percent_A:49
                progstr_a = strcat(progstr_a,'.');
            end
            msg_a = sprintf(strcat('Progress (hive): [',progstr_a,']\n'), t_d, Prop.Sim.eval_time_days);
            fprintf([reversestr_a, msg_a]);
            reversestr_a = repmat(sprintf('\b'), 1, length(msg_a));
            percent_A_old = percent_A;
        end
        
    end
    fprintf('\n');
    
    % TEMP:
    hives(1).plot();
    
    fprintf('Saving report...\n');
    report.save();
    fprintf('Simulation finished.\n');
    fprintf('#########################################################\n');
end