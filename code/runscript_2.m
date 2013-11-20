% This is a runscript for automatized simulation on any system

% Simple test cases based on Properties_Base
run('data\Properties_Base.m');

% Load the properties into memory, make copies and modify them on the go

% The testcases, variable change 1:
% 1. all flowers
% 2. no spring flowers
% 3. no summer flowers
% 4. no autumn flowers

% The testcases, variable change 2:
% 1. Autumn flowers shifted by 4 days
% 2. Autumn flowers shifted by 8 days
% 3. Autumn flowers shifted by 12 days
% 4. Autumn flowers shifted by 16 days
% 5. Autumn flowers shifted by 20 days

% Empty proparray at first
proparray = [];

% 4 possible peaks to test
peaks = [2,1.5,1,0.5];

for j=1:5
    for i=1:4
        identifier = strcat('Properties_Base_R2_',num2str(i),'_',num2str(j));
        tprop = Prop;
        tprop.Sys.identifier = identifier;
        tprop.Sim.Flower(3).year_activity(1,:) = tprop.Sim.Flower(3).year_activity(1,:) + j * 4;
        tprop.Sim.Flower(3).peak = peaks(i);
        proparray = [proparray, tprop];
    end
end

% Start simulation
hive_simulation(proparray);