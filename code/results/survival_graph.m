function [ survival_matric ] = survival_graph( run_data )
%SURVIVAL_GRAPH Summary of this function goes here
%   Detailed explanation goes here
[I,J] = size(run_data);
survival_matric = ones(I,J);
for i =1:I
    for j = 1:J
        if run_data{i,j}.data.hives.food_storage(1,400)<= 20000 || run_data{i,j}.data.hives.hive_bees(1,400)<= 1000;
            survival_matric(i,j)=0;
        end
    end
end
            


end

