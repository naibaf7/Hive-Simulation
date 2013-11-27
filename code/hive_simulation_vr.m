function hive_simulation_vr()

    fprintf('#################### HIVE-SIMULATION ####################\n');

    % Ask user to input a properties file for the simulation
    [file_name, path_name] = uigetfile('*.m','Select simulation property file');

    fprintf('Loading properties...\n');

    % Construct absolute loading path
    load_properties = strcat(path_name,file_name);

    % Load properties
    run(load_properties);
    
    % Fixed food rate until environment simulation day.
    Prop.Sim.Hive(1).fixed_food_rate = 1;
    % Record environment simulation on this day (VR).
    record_day = 158;
    
    proparray = [Prop];      
    
    % Initialize report
    fprintf('Initializing report...\n');
    for k = 1:length(proparray)
        report(k) = Report(proparray(k));
    end
    
    vid_obj = VideoWriter('video.avi');
    open(vid_obj);
    h = figure();
    set(h, 'Position', [300, 150, 1024, 768]); 
    
    
    runtime_start = tic;
    % Parfor loop allows simulating multiple scenarios at once
    for k = 1:length(proparray)
        Prop = proparray(k);
        % Initialize world
        fprintf('Initializing world...\n');
        world = World(Prop);

        % Initialize hives
        fprintf('Initializing hives...\n');
        hives = Hive_vr.empty(Prop.Sim.hive_count, 0);
        for i = 1:Prop.Sim.hive_count
            hives(i) = Hive_vr(i, world, Prop);
        end
        

        % Start simulation
        fprintf('Starting simulation (%d days)...\n', Prop.Sim.eval_time_days);

        reversestr_a = '';
        reversestr_b = '';
        percent_A_old = -1;
        percent_B_old = -1;
        % Counter for indexing data collection
        sim_day = 1;
        for t_d = 1:Prop.Sim.eval_time_days
            % Re-evaluate environment if there is any need for it
            % The need is defined by checking if some flower is active at the
            % moment.
            activity_sum = sum(sum(world.quality_map.array));

            if t_d == record_day
                hives(1).fixed_food_rate = 0;
            else
                if t_d > record_day
                    hives(1).fixed_food_rate = 1;
                end
            end
                        
            
            % Check for extinct hives and hives with constant food rate
            dont_calculate_sum = 0;
            for i = 1:Prop.Sim.hive_count
                if(hives(i).fixed_food_rate || hives(i).is_extinct)
                    dont_calculate_sum = dont_calculate_sum + 1;
                end
            end

            % There is activity, and there are some hives which are not extinct
            % and don't have constant food rate, so do environment simulation
            if(activity_sum > 0 && dont_calculate_sum ~= Prop.Sim.hive_count)
                dt_s = Prop.Sim.eval_step_seconds;
                for i = 1:Prop.Sim.hive_count
                    % Reset environment simulation for new day
                    hives(i).reset_s(t_d);
                end
                % Counter for indexing data collection
                sim_second = 1;
                for i = 1:Prop.Sim.hive_count
                    % Write corresponding day to this simulated day into the
                    % report
                    report(k).data.hives(i).day(sim_day).actual_day = t_d;
                    % Record data at t_d into field sim_day
                    report(k).data.hives(i).day(sim_day).patches_total = hives(i).patches_total;
                end
                for t_s = 1:Prop.Sim.eval_time_seconds
                    if(mod(t_s-1,dt_s)==0)
                        for i = 1:Prop.Sim.hive_count
                            if(~hives(i).is_extinct && hives(i).fixed_food_rate == 0)
                                hives(i).simulate_s(t_s, t_d, dt_s);
                            end
                        end
                    end
                    if(mod(t_s-1,Prop.Sim.record_step_seconds)==0)
                        for i = 1:Prop.Sim.hive_count
                            % Write corresponding time to this simulated time into the
                            % report
                            report(k).data.hives(i).day(sim_day).actual_time(sim_second) = t_s;
                            % Record data at t_s into field sim_second
                            report(k).data.hives(i).day(sim_day).patches_discovered(sim_second) = hives(i).patches_discovered;
                            report(k).data.hives(i).day(sim_day).food_sum(sim_second) = hives(i).daily_food_sum(t_d);
                            report(k).data.hives(i).day(sim_day).scouts_count(sim_second) = hives(i).scouts_count;
                            report(k).data.hives(i).day(sim_day).forager_count(sim_second) = hives(i).bees_count;
                        end
                        sim_second = sim_second + 1;
                    end
                    % TODO: COMMENT OUT AGAIN
                     if(mod(t_s,60)==0)
                         hives(1).draw_s(h, vid_obj);
                         %world.draw_s();
                         pause(0.1);
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
                sim_day = sim_day + 1;
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

        % Record simulation data

        for i = 1:Prop.Sim.hive_count
            report(k).data.hives(i).uncapped_brood = hives(i).B;
            report(k).data.hives(i).hive_bees = hives(i).H;
            report(k).data.hives(i).food_storage = hives(i).f;
            report(k).data.hives(i).foragers = hives(i).F;
            report(k).data.hives(i).daily_food_sum = hives(i).daily_food_sum;
        end

    end
    runtime_stop = toc(runtime_start);
    
    % Don't save any report of this
    %fprintf('Saving report...\n');
    %for k = 1:length(proparray)
    %    report(k).save();
    %end
    
    fprintf('Simulation finished. Used %fs.\n',runtime_stop);
    fprintf('#########################################################\n');
end