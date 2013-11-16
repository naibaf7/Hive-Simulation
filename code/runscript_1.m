% This is a runscript for automatized simulation on any system

% Simple test cases based on Properties_Base
run('data\Properties_Base.m');

% Load the properties into memory, make copies and modify them on the go

% The testcases:
% 1. all flowers
% 2. no spring flowers
% 3. no summer flowers
% 4. no autumn flowers

Prop1 = Prop;
Prop1.Sys.identifier = 'Properties_Base_R1_1';

Prop2 = Prop;
Prop2.Sim.Flower(1).year_activity = [1:2;0,0];
Prop2.Sys.identifier = 'Properties_Base_R1_2';

Prop3 = Prop;
Prop3.Sim.Flower(2).year_activity = [1:2;0,0];
Prop3.Sys.identifier = 'Properties_Base_R1_3';

Prop4 = Prop;
Prop4.Sim.Flower(3).year_activity = [1:2;0,0];
Prop4.Sys.identifier = 'Properties_Base_R1_4';


proparray=[Prop1,Prop2,Prop3,Prop4];

% Start simulation
hive_simulation(proparray);