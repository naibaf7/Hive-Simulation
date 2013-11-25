function analyze_report( obj )
%ANALYZE_REPORT generates graphes for a single simulation run
%   Generates one graph and saves them as .eps and .fig
%   - count of active food patches and their quality

test_time = 365;

%Calculate flower activity
flower_activity = zeros(1,test_time);
for i = 1:4
    for j = 1:size(obj.prop.Sim.Flower(1, i).year_activity,2)
        flower_activity(obj.prop.Sim.Flower(1, i).year_activity(1,j))=flower_activity(obj.prop.Sim.Flower(1, i).year_activity(1,j)) + obj.prop.Sim.Flower(1, i).peak *obj.prop.Sim.Flower(1, i).year_activity(2,j);
    end
end


%put data in matrix

plot_data(12,:) =(flower_activity)%/max(flower_activity))*100;
%Draw
fig = figure('name',obj.prop.Sys.identifier);
set(gcf,'PaperPositionMode','auto','PaperUnit','inches','PaperSize',[5, 2])
%set(fig, 'Position', [0 0 944 1024])
%Draw iterative Graph


%Draw Patches
plot(transp(plot_data(12:12,:)),'-','Color',[0 0.5 0],'LineWidth', 2)
grid on
xlim([0 test_time])
%Add Graph Descriptions
title('flower blooming and quality')
legend('quality/blooming indicator')
legend('Location','NorthWest')
xlabel('t [d]')
ylabel('M [kg/d]')

%Save as eps and matlab fig
print(fig,'seasonal_flowers','-depsc2');
saveas(fig,'seasonal_flowers','fig');



end

