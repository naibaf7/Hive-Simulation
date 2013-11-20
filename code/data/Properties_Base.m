% This is a sample file as reference. For actual simulations, make a copy!

% SYSTEM
% Identifier for data record
Prop.Sys.identifier = 'Properties_Base';
% If parallelization is possible, max. processors that should be used
Prop.Sys.cores = 6;

% WORLD
% See "Wisdom of the Hive", P. 49 why this is a reasonable size for
% simulation, as most flower patches detected will be in this area and the
% 95th percentile is within 6km radius of the hive. This implies 100km^2 is
% sufficient
Prop.Sim.world_size = 10000;            % Meters
% 100m^2 raster size (10m * 10m) is a reasonable scaling for the map as
% flower patches, respective rastered areas can be assumed to be at least
% 100m^2, which was also the seeding size mentioned ("Wisdom of the Hive",
% P. 51)
Prop.Sim.world_size_10 = Prop.Sim.world_size/10;
Prop.Sim.world_file = 'data\equal_dist_normal.png'; % Image file the world is based on
Prop.Sim.eval_time_days = 470;           % Days of simulation per run
Prop.Sim.eval_time_seconds = 12*60*60;   % Seconds of simulation per day
Prop.Sim.eval_step_seconds = 60;         % Seconds between two evaluation points
Prop.Sim.record_step_seconds = 15*60;    % Daily simulation recording step size

% Flowers
% Describes how vital flowers are during a year
% From 1 to 365, arbitrary measure points + paddings
% Taken from P. 45, "Wisdom of the Hive"
% 2xN vectors, days vs. activity factor
% Peak values are in hive weight change in kg per day.
% Assuming bee count = 10'000, we get peak/10'000 = kg/bee/day
% which * 1000 gives g/bee/day, what we need. Therefore we assume this is
% the weight of pollen/nectar a bee can get per flight and flower.
% Therefore we can take hive weight change/day as indicator for
% flower/pollen quality at a given day in the year.

% Final equation: peak * daily quality * 1/100 = reward per flower visit in
% grams.


% Flowers (mainly active during spring):
Prop.Sim.Flower(1).peak = 1.8;
Prop.Sim.Flower(1).year_activity = [131:140;sin(linspace(0,pi,10))];
% Woods (mainly active during summer):
Prop.Sim.Flower(2).peak = 6;
Prop.Sim.Flower(2).year_activity = [154:161,175:182,190:195;sin(linspace(0,pi,8)),sin(linspace(0,pi,8))/1.5,sin(linspace(0,pi,6))/6];
% Fruits (mainly active during autumn:
Prop.Sim.Flower(3).peak = 2;
Prop.Sim.Flower(3).year_activity = [245:270;sin(linspace(0,pi,26))];

% Left empty for future use:
Prop.Sim.Flower(4).peak = 0;
Prop.Sim.Flower(4).year_activity = [1:2;0,0];

% Maybe we'll implement smog later on, maybe not...
Prop.Sim.Smog.year_activity = [0,0;0,0];        % TODO

% HIVES
% Hive 1
% Most values from the reference paper
Prop.Sim.hive_count = 1;
Prop.Sim.Hive(1).x_pos = Prop.Sim.world_size_10/2;
Prop.Sim.Hive(1).y_pos = Prop.Sim.world_size_10/2;
Prop.Sim.Hive(1).uncapped_brood = 0;
Prop.Sim.Hive(1).hive_bees = 16000;
Prop.Sim.Hive(1).foragers = 8000;
Prop.Sim.Hive(1).food_brood_eff = 500;
Prop.Sim.Hive(1).hive_brood_eff = 5000;
Prop.Sim.Hive(1).aging_time = 12;
Prop.Sim.Hive(1).mortality = 0.075;
Prop.Sim.Hive(1).min_recruitment = 0.25;
Prop.Sim.Hive(1).max_recruitment = 0.25;
% Describes how the laying rate of the queen varies during the year
% From 1 to 365, arbitrary measure points + paddings
% Taken from P. 34ff, "Wisdom of the Hive"
% Approx. laying from April/May to October, in winter only to keep the hive
% alive
% 2xN vectors, days vs. laying factor
Prop.Sim.Hive(1).laying_function = [-30,1,32,60,91,121,153,182,213,244,274,305,335,366,395;0.1,0.1,0.1,0.1,0.5,1,2,2,1,0.5,0.1,0.1,0.1,0.1,0.1];
Prop.Sim.Hive(1).laying_rate = 2000;
Prop.Sim.Hive(1).social_inhibition = 0.75;
Prop.Sim.Hive(1).adult_bee_emerging = 1/9;
Prop.Sim.Hive(1).food_per_forager = 0.1;
Prop.Sim.Hive(1).food = 50000;
% Food consumption adult bees, 0.007g/day
Prop.Sim.Hive(1).food_consumption_adult = 0.007;
% Food consumption brood/larvae, 0.018g/day
Prop.Sim.Hive(1).food_consumption_brood = 0.018;

% Describes how many bees fly out at a given daytime
% From 08:00 to 20:00, 12 hours, one measure point / hour + paddings
% Taken from P. 86 "Wisdom of the Hive"
% 2xN vector, hours vs. activity
Prop.Sim.Hive(1).daily_activity =  [-1,1,2,3,4,5,6,7,8,9,10,11,12,13;-1,0.1,0.5,1,0.95,0.9,0.9,0.9,0.9,0.95,1,0.5,0.1,-1];
% Barrier for extinction. If total bee count is lower than this, a hive is
% considered extinct (no more computation, all values constant and/or zero)
Prop.Sim.Hive(1).extinct_barrier = 500;
% Max. percentage of foragers that are scouts
% Taken from P. 86 "Wisdom of the Hive", an average value
% 6% or 0.06 (normalized)
Prop.Sim.Hive(1).scout_count = 0.06;

% BEES
% Max. food carried by bee, average value, P. 42 "Wisdom of the Hive"
% 25mg or 0.025g
Prop.Sim.Hive(1).Bee.max_food = 0.025;
% Max. flight distance of a bee
% 8km or 8000m, use 2km padding to world borders in 10m resolution
Prop.Sim.Hive(1).Bee.max_dist = 8000/10;
% Probability to optimize a path during one way
% 50% chance. This is a freely chosen
% property for the random walk algorithm!
Prop.Sim.Hive(1).Bee.optimize_prob = 0.5;
% Factor to change movement angle, multiplied by randn();. This is a freely
% chosen property for the random walk algorithm!
Prop.Sim.Hive(1).Bee.rotate_scale = 0.5;
% Time after which to set a new waypoint (s). This is a freely chosen
% property for the random walk algorithm!
Prop.Sim.Hive(1).Bee.change_waypoint = 60;
% Flight speed
% Taken from P. 47 "Wisdom of the Hive"
% 25km/h or 7m/s, divided by ten as we work in 10m resolution
Prop.Sim.Hive(1).Bee.flight_speed = 7/10;

% An average of 5min spent to evaluate a flower patch
% Assumption made based on flight speed and patch size
Prop.Sim.Hive(1).scouting_eval_time = 3*60;

% An average of 4min spent to dispatch food and get a new patch assigned,
% respectively doing a waggle dance
% Assumption made based on "Wisdom of the Hive", P. 107f
Prop.Sim.Hive(1).dispatch_time = 4*60;

% An average of 1min spent to collect food at the flower patch
% Assumption made based on "Wisdom of the Hive", P. 107ff
Prop.Sim.Hive(1).collect_time = 1*60;

% Maximum amount of bees simulated (if bee count is higher than this,
% aggregated bee clusters will be simulated)
Prop.Sim.Hive(1).max_forager_clusters = 1000;

% Food rate is dynamic (environment simulation)
Prop.Sim.Hive(1).fixed_food_rate = 0;








