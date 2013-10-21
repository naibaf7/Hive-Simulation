% This is a sample file as reference. For actual simulations, make a copy!

% SYSTEM
Prop.Sys.identifier = 'Properties_Base';
Prop.Sys.cores = 8;
Prop.Sys.record_video = 0;


% WORLD
Prop.Sim.world_size = 1000;            % Meters
Prop.Sim.eval_step_days = 14;           % Days
Prop.Sim.eval_time_days = 365;          % Days
Prop.Sim.eval_time_seconds = 24*60*60;  % Seconds


% HIVES
% Hive 1
Prop.Sim.hive_count = 1;
Prop.Sim.Hive(1).x_pos = 0;
Prop.Sim.Hive(1).y_pos = 0;
Prop.Sim.Hive(1).uncapped_brood = 0;
Prop.Sim.Hive(1).hive_bees = 16000;
Prop.Sim.Hive(1).foragers = 8000;
Prop.Sim.Hive(1).food_brood_eff = 500;
Prop.Sim.Hive(1).hive_brood_eff = 5000;
Prop.Sim.Hive(1).aging_time = 12;
Prop.Sim.Hive(1).mortality = 0.3;
Prop.Sim.Hive(1).min_recruitment = 0.25;
Prop.Sim.Hive(1).max_recruitment = 0.25;
Prop.Sim.Hive(1).laying_rate = 2000;
Prop.Sim.Hive(1).social_inhibition = 0.75;
Prop.Sim.Hive(1).adult_bee_emerging = 1/9;
Prop.Sim.Hive(1).food_per_forager = 0.1;
Prop.Sim.Hive(1).food = 0;
% Food consumption, 0.007g/day
Prop.Sim.Hive(1).food_consumption_adult = 0.007;
% Food consumption, 0.018g/day
Prop.Sim.Hive(1).food_consumption_brood = 0.018;
%...


% BEES
% Max. food carried by bee, average value, P. 42 "Wisdom of the Hive"
% 25mg or 0.025g
Prop.Sim.Bee.max_food = 0.025;
% Max. flight distance of a bee
% 8km or 8000m, use 2km padding to world borders
Prop.Sim.Bee.max_dist = 8000;



