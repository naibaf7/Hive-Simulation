function analyze_report( obj )
%ANALYZE_REPORT generates graphes for a single simulation run
%   Generates one graph and saves them as .eps and .fig
%   - count of active food patches and their quality

test_time = obj.prop.Sim.eval_time_days+1;

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

plot_data(11,:) = patches;
plot_data(12,:) =(flower_activity/max(flower_activity))*100;
%Draw
fig = figure('name',obj.prop.Sys.identifier);
set(gcf,'PaperPositionMode','auto','PaperType','A4')
set(fig, 'Position', [0 0 944 1024])
%Draw iterative Graph


%Draw Patches
plot(transp(plot_data(11:12,:)),'-','LineWidth', 2)
xlim([0 test_time])
%Add Graph Descriptions
title('patches and quality')
legend('patches','flower quality')
legend('Location','NorthWest')
xlabel('days')
ylabel('count / %')

%Save as A4 eps and matlab fig
print(fig,obj.prop.Sys.identifier,'-depsc2');
saveas(fig,obj.prop.Sys.identifier,'fig');



end

