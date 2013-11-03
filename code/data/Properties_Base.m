% This is a sample file as reference. For actual simulations, make a copy!

% SYSTEM
Prop.Sys.identifier = 'Properties_Base';
Prop.Sys.cores = 8;
Prop.Sys.record_video = 0;


% WORLD
Prop.Sim.world_size = 10000;            % Meters
Prop.Sim.world_file = 'data\test2.png';  % Image file the world is based on
Prop.Sim.eval_step_days = 14;           % Days
Prop.Sim.eval_time_days = 365*3;        % Days
Prop.Sim.eval_time_seconds = 12*60*60;  % Seconds
Prop.Sim.eval_step_seconds = 5;         % Seconds

% Flowers
% Describes how vital flowers are during a year
% From 1 to 365, arbitrary measure points + paddings
% Taken from P. 45, "Wisdom of the Hive"
% 2xN vectors, days vs. activity factor
% Peak values are in hive weight change in kg per day.
% Assuming bee count = 100'000, we get peak/100'000 = kg/bee/day
% which * 1000 gives g/bee/day, what we need. Therefore we assume this is
% the weight of pollen/nectar a bee can get per flight and flower.
% Therefore we can take hive weight change/day as indicator for
% flower/pollen quality at a given day in the year.

% Final equation: peak * daily quality * 1/100 = reward per flower visit in
% grams.


% Dandelion (peak value 1.7):
% Prop.Sim.Flower(1).peak = 1.7;
% Prop.Sim.Flower(1).year_activity = [120:149;0.0588,0,0.1176,0.1765,-0.1765,-0.0588,0.1176,0.1176,-0.1176,-0.1765,-0.1765,-0.0588,-0.0588,0.2941,0.2941,0.2941,1.0,0.5882,0.5882,0.6471,0.0588,0.2353,0.8824,-0.1765,-0.5882,-0.0588,-0.1176,-0.1765,-0.1765,-0.1176];
% Black locust (peak value 5.9):
% Prop.Sim.Flower(2).peak = 5.9;
% Prop.Sim.Flower(2).year_activity = [150:159;0,0.271186440677966,0.677966101694915,0.694915254237288,1,0.389830508474576,0.0847457627118644,0.254237288135593,0.220338983050847,-0.0169491525423729];
% Raspberry + sumac (peak value 4.3)
% Prop.Sim.Flower(3).peak = 4.3;
% Prop.Sim.Flower(3).year_activity = [160:179;-0.0465116279069768,-0.0465116279069768,-0.0465116279069768,-0.0232558139534884,0,-0.0232558139534884,0.325581395348837,-0.0465116279069768,0.279069767441860,-0.116279069767442,0.883720930232558,0.813953488372093,0.883720930232558,1,0.441860465116279,0,0.418604651162791,0.813953488372093,0.883720930232558,-0.186046511627907];
% Basswood (peak value 0.6)
% Prop.Sim.Flower(4).peak = 0.6;
% Prop.Sim.Flower(4).year_activity = [180:209;-1,-5/6,-0.5,-1/3,-1/3,1,5/6,1,1,5/3,-1/3,-5/6,-5/3,-1/3,1/3,-0.5,0,1/3,1/3,-5/6,0,0.5,1/3,-5/6,-5/3,0,-2/3,-0.5,-1/3,-1/3];


% Hive weight change in kg/d for seasons. Spring: flowers, summer: woods,
% autumn: unspecified. The 4th slot is interchangable/winter.
% Spring flowers, p.45 in Wisdom of the Hive (dandelion, black locust, raspberry, sumac, peak value 5.9): 
%Prop.Sim.Flower(1).peak = 5.9;
%Prop.Sim.Flower(1).year_activity = [121:179;0.0169423728813559,0,0.0338847457627119,0.0508559322033898,-0.0508559322033898,-0.0169423728813559,0.0338847457627119,0.0338847457627119,-0.0338847457627119,-0.0508559322033898,-0.0508559322033898,-0.0169423728813559,-0.0169423728813559,0.0847406779661017,0.0847406779661017,0.0847406779661017,0.288135593220339,0.169481355932203,0.169481355932203,0.186452542372881,0.0169423728813559,0.0677983050847458,0.254250847457627,-0.0508559322033898,-0.169481355932203,-0.0169423728813559,-0.0338847457627119,-0.0508559322033898,-0.0508559322033898,-0.0338847457627119,0.271186440677966,0.677966101694915,0.694915254237288,1,0.389830508474576,0.0847457627118644,0.254237288135593,0.220338983050847,-0.0169491525423729,-0.0338983050847458,-0.0338983050847458,-0.0338983050847458,-0.0169491525423729,0,-0.0169491525423729,0.237288135593220,-0.0338983050847458,0.203389830508474,-0.0847457627118645,0.644067796610169,0.593220338983051,0.644067796610169,0.728813559322034,0.322033898305085,0,0.305084745762712,0.593220338983051,0.644067796610169,-0.135593220338983];
% Summer woods, p.45 in Wisdom of the Hive (basswood, peak value 0.6)
%Prop.Sim.Flower(2).peak = 0.6;
%Prop.Sim.Flower(2).year_activity = [180:209;-1,-5/6,-0.5,-1/3,-1/3,1,5/6,1,1,5/3,-1/3,-5/6,-5/3,-1/3,1/3,-0.5,0,1/3,1/3,-5/6,0,0.5,1/3,-5/6,-5/3,0,-2/3,-0.5,-1/3,-1/3];
% Autumn (Sep-Nov [currently only data for Sep available and implemented)), p.44 in Wisdom of the Hive (unspecified flowers)
%Prop.Sim.Flower(3).peak = 4.9;
%Prop.Sim.Flower(3).year_activity = [240:269;0.918367346938775,0.918367346938775,0.918367346938775,0.918367346938775,0.918367346938775,0.918367346938775,0.918367346938775,0.938775510204082,0.938775510204082,0.938775510204082,0.938775510204082,0.938775510204082,0.938775510204082,0.938775510204082,1,1,1,1,1,1,1,0.326530612244898,0.326530612244898,0.326530612244898,0.326530612244898,0.326530612244898,0.326530612244898,0.326530612244898,0.204081632653061,0.102040816326531];
% unspecified
%Prop.Sim.Flower(4).peak = 0.0;
%Prop.Sim.Flower(4).year_activity = [330:359;0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];


% Flowers (mainly active during spring):
Prop.Sim.Flower(1).peak = 1.8;
Prop.Sim.Flower(1).year_activity = [131:140;sin(linspace(0,pi,10))];
% Woods (mainly active during summer):
Prop.Sim.Flower(2).peak = 6;
Prop.Sim.Flower(2).year_activity = [154:161,175:182,190:195;sin(linspace(0,pi,8)),sin(linspace(0,pi,8))/1.5,sin(linspace(0,pi,6))/6];
% Fruits (mainly active during autumn:
Prop.Sim.Flower(3).peak = 5;
Prop.Sim.Flower(3).year_activity = [245:270;sin(linspace(0,pi,26))];

% Left empty for future use:
Prop.Sim.Flower(4).peak = 0;
Prop.Sim.Flower(4).year_activity = [1:2;0,0];

% Maybe we'll implement smog later on, maybe not...
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
% Max. percentage of foragers that are scouts
% Taken from P. 86 "Wisdom of the Hive", an average value
% 6% or 0.06 (normalized)
Prop.Sim.Hive(1).scout_count = 0.06;





