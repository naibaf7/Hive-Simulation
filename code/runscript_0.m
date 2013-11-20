% This is a runscript for automatized simulation on any system

% Simple test cases based on Properties_Base
run('data\Properties_Base.m');

% Load the properties into memory, make copies and modify them on the go

% The testcases:
% 1. Original model (constant food, constant laying rate, original mortality)
% 2. Intermediate model (constant food, varying laying rate, adapted mortality)

Prop1 = Prop;
Prop1.Sim.Hive(1).fixed_food_rate = 1;
Prop1.Sim.Hive(1).mortality = 0.3;
Prop1.Sim.Hive(1).laying_function = [0,1,2;1,1,1];
Prop1.Sys.identifier = 'Properties_Base_R0_1';

Prop2 = Prop;
Prop2.Sim.Hive(1).fixed_food_rate = 1;
Prop2.Sys.identifier = 'Properties_Base_R0_2';


proparray=[Prop1,Prop2];

% Start simulation
hive_simulation(proparray);