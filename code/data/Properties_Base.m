% This is a sample file as reference. For actual simulations, make a copy!

% SYSTEM
Prop.Sys.identifier = 'Properties_Base';
Prop.Sys.cores = 8;
Prop.Sys.record_video = 0;


% WORLD
Prop.Sim.world_size = 10000;            % Meters
Prop.Sim.world_file = 'data\test.png';       % Image file the world is based on
Prop.Sim.eval_step_days = 14;           % Days
Prop.Sim.eval_time_days = 365*3;        % Days
Prop.Sim.eval_time_seconds = 12*60*60;  % Seconds
Prop.Sim.eval_step_seconds = 5;         % Seconds

% Flowers
% Describes how vital flowers are during a year
% From 1 to 365, arbitrary measure points + paddings
% Taken from P. 45, "Wisdom of the Hive"
% 2xN vectors, days vs. activity factor
% Dandelion:
Prop.Sim.Flower(1).year_activity = [0,0;0,0];   % TODO
% Black locust:
Prop.Sim.Flower(2).year_activity = [0,0;0,0];   % TODO
% Raspberry + sumac
Prop.Sim.Flower(3).year_activity = [0,0;0,0];   % TODO
% Basswood
Prop.Sim.Flower(4).year_activity = [0,0;0,0];   % TODO

Prop.Sim.Smog.year_activity = [0,0;0,0];        % TODO

% HIVES
% Hive 1
Prop.Sim.hive_count = 1;
Prop.Sim.Hive(1).x_pos = Prop.Sim.world_size/2;
Prop.Sim.Hive(1).y_pos = Prop.Sim.world_size/2;
Prop.Sim.Hive(1).uncapped_brood = 0;
Prop.Sim.Hive(1).hive_bees = 16000;
Prop.Sim.Hive(1).foragers = 8000;
Prop.Sim.Hive(1).food_brood_eff = 500;
Prop.Sim.Hive(1).hive_brood_eff = 5000;
Prop.Sim.Hive(1).aging_time = 12;
Prop.Sim.Hive(1).mortality = 0.05;
Prop.Sim.Hive(1).min_recruitment = 0.25;
Prop.Sim.Hive(1).max_recruitment = 0.25;
% Describes how the laying rate of the queen varies during the year
% From 1 to 365, arbitrary measure points + paddings
% Taken from P. 34pp, "Wisdom of the Hive"
% Approx. laying from March to October
% 2xN vectors, days vs. laying factor
Prop.Sim.Hive(1).laying_function = [-30,1,32,60,91,121,153,182,213,244,274,305,335,366,395;-4,-3,-2,-1,0.5,1,2,2,1,0.5,0,-1,-2,-3,-4];
Prop.Sim.Hive(1).laying_rate = 2000;
Prop.Sim.Hive(1).social_inhibition = 0.75;
Prop.Sim.Hive(1).adult_bee_emerging = 1/9;
Prop.Sim.Hive(1).food_per_forager = 0.1;
Prop.Sim.Hive(1).food = 0;
% Food consumption adult bees, 0.007g/day
Prop.Sim.Hive(1).food_consumption_adult = 0.007;
% Food consumption brood/larvae, 0.018g/day
Prop.Sim.Hive(1).food_consumption_brood = 0.018;

% Describes how many bees fly out at a given daytime
% From 08:00 to 20:00, 12 hours, one measure point / hour + paddings
% Taken from P. 86 "Wisdom of the Hive"
% 2xN vector, hours vs. activity
Prop.Sim.Hive(1).daily_activity =  [-1,1,2,3,4,5,6,7,8,9,10,11,12,13;-1,0.1,0.5,1,0.95,0.9,0.9,0.9,0.9,0.95,1,0.5,0.1,-1];


% BEES
% Max. food carried by bee, average value, P. 42 "Wisdom of the Hive"
% 25mg or 0.025g
Prop.Sim.Hive(1).Bee.max_food = 0.025;
% Max. flight distance of a bee
% 8km or 8000m, use 2km padding to world borders
Prop.Sim.Hive(1).Bee.max_dist = 8000;
% Probability to optimize a path during one way
% 50% chance
Prop.Sim.Hive(1).Bee.optimze_prob = 0.5;
% Factor to change movement angle, multiplied by randn();
Prop.Sim.Hive(1).Bee.rotate_scale = 0.1;
% Average time factor to set a waypoint, multiplied by randn();
Prop.Sim.Hive(1).Bee.change_waypoint = 10;
% Flight speed
% Taken from P. 47 "Wisdom of the Hive"
% 25km/h or 7m/s
Prop.Sim.Hive(1).flight_speed = 7;




