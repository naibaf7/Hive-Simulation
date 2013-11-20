function analyze_report( obj )
%ANALYZE_REPORT generates graphes for a single simulation run
%   Generates four Graphes and saves them as .eps and .fig
% Included Graphes:
%   -Hive Statistics
%   -daily change in stored food and bees
%   -daily max/min of scouts and foragers
%   - count of active food patches and their quality
%

test_time = obj.prop.Sim.eval_time_days+1;

%Calculate daily bee population and food change
bee_change = zeros(1,test_time);
food_change = zeros(1,test_time);

for i = 2:test_time;
    bee_change(i) = obj.data.hives.hive_bees(i) - obj.data.hives.hive_bees(i-1) + obj.data.hives.foragers(i) - obj.data.hives.foragers(i-1);
    food_change(i) = obj.data.hives.food_storage(i) - obj.data.hives.food_storage(i-1);
end

%Caclculate daily min/max of scouts and foragers
scouts_min = zeros(1,test_time);
scouts_max = zeros(1,test_time);
foragers_min = zeros(1,test_time);
foragers_max = zeros(1,test_time);

for i = 1:size(obj.data.hives.day,2);
    scouts_min(obj.data.hives.day(1,i).actual_day)=min(obj.data.hives.day(1,i).scouts_count);
    scouts_max(obj.data.hives.day(1,i).actual_day)=max(obj.data.hives.day(1,i).scouts_count);
    foragers_min(obj.data.hives.day(1,i).actual_day)=min(obj.data.hives.day(1,i).forager_count);
    foragers_max(obj.data.hives.day(1,i).actual_day)=min(obj.data.hives.day(1,i).forager_count);
end
%Calculate flower activity
flower_activity = zeros(1,test_time);
for i = 1:4
    for j = 1:size(obj.prop.Sim.Flower(1, i).year_activity,2)
        flower_activity(obj.prop.Sim.Flower(1, i).year_activity(1,j))=flower_activity(obj.prop.Sim.Flower(1, i).year_activity(1,j)) + obj.prop.Sim.Flower(1, i).peak *obj.prop.Sim.Flower(1, i).year_activity(2,j);
    end
end

%Calculate active patches
patches = zeros(1,test_time);

for i = 1:size(obj.data.hives.day,2);
    patches(obj.data.hives.day(1,i).actual_day)=obj.data.hives.day(1,i).patches_total;
end
%put data in matrix
plot_data(1,:) = obj.data.hives.uncapped_brood;
plot_data(2,:) = obj.data.hives.foragers;
plot_data(3,:) = obj.data.hives.hive_bees;
plot_data(4,:) = obj.data.hives.food_storage;
plot_data(5,:) = bee_change;
plot_data(6,:) = (food_change/10);
plot_data(7,:) = scouts_min;
plot_data(8,:) = scouts_max;
plot_data(9,:) = foragers_min;
plot_data(10,:)= foragers_max;
plot_data(11,:) = patches;
plot_data(12,:) =(flower_activity/max(flower_activity))*100;
%Draw
fig = figure('name',obj.prop.Sys.identifier);
set(gcf,'PaperPositionMode','auto','PaperType','A4')
set(fig, 'Position', [0 0 944 1024])
%Draw iterative Graph
s(1) = subplot(4,1,1);
plot(transp(plot_data(1:4,:)),'-','LineWidth', 2);
xlim([0 test_time])
%Add Graph Descriptions
legend('uncapped brood','forager bees','hive bees','stored food')
legend('Location','NorthWest')
title('hive statistics')
xlabel('days')
ylabel('count / grams')

%Draw bee and food change
s(2) = subplot(4,1,2);
plot(transp(plot_data(5:6,:)),'-','LineWidth', 2)
xlim([0 test_time])
%Add Graph Descriptions
title('bee and food change')
legend('bee change','food change')
legend('Location','NorthWest')
xlabel('days')
ylabel('(bees or 10g)/day')

%Draw daily min/max of scouts and foragers
s(3) = subplot(4,1,3);
plot(transp(plot_data(7:10,:)),'-','LineWidth', 2)
xlim([0 test_time])
%Add Graph Descriptions
title('daily min/max of scouts and foragers')
legend('scouts min','scouts max','foragers min','foragers max')
legend('Location','NorthWest')
xlabel('days')
ylabel('bees')

%Draw Patches
s(4) = subplot(4,1,4);
plot(transp(plot_data(11:12,:)),'-','LineWidth', 2)
xlim([0 test_time])
%Add Graph Descriptions
title('patches and quality')
legend('patches','flower quality')
legend('Location','NorthWest')
xlabel('days')
ylabel('count / %')

%Link all the x-axis
linkaxes( s, 'x')
%Save as A4 eps and matlab fig
print(fig,obj.prop.Sys.identifier,'-depsc2');
saveas(fig,obj.prop.Sys.identifier,'fig');



end

