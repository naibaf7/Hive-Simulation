function analyze_report( obj )
%ANALYZE_REPORT generates graphes for a single simulation run
%   Generates four Graphes and saves them as .eps and .fig
% Included Graphes:
%   -Hive Statistics
%   -daily change in stored food and bees
%   -daily max/min of scouts and foragers
%   - count of active food patches and their quality
%



%Calculate daily bee population and food change
bee_change = zeros(1,obj.prop.Sim.eval_time_days);
food_change = zeros(1,obj.prop.Sim.eval_time_days);

for i = 2:obj.prop.Sim.eval_time_days;
    bee_change(i) = obj.data.hives.hive_bees(i) - obj.data.hives.hive_bees(i-1) + obj.data.hives.foragers(i) - obj.data.hives.foragers(i-1);
    food_change(i) = obj.data.hives.food_storage(i) - obj.data.hives.food_storage(i-1);
end

%Caclculate daily min/max of scouts and foragers
scouts_min = zeros(1,obj.prop.Sim.eval_time_days);
scouts_max = zeros(1,obj.prop.Sim.eval_time_days);
foragers_min = zeros(1,obj.prop.Sim.eval_time_days);
foragers_max = zeros(1,obj.prop.Sim.eval_time_days);

for i = 1:size(obj.data.hives.day,2);
   scouts_min(obj.data.hives.day(1,i).actual_day)=min(obj.data.hives.day(1,i).scouts_count);
   scouts_max(obj.data.hives.day(1,i).actual_day)=max(obj.data.hives.day(1,i).scouts_count);
   foragers_min(obj.data.hives.day(1,i).actual_day)=min(obj.data.hives.day(1,i).forager_count);
   foragers_max(obj.data.hives.day(1,i).actual_day)=min(obj.data.hives.day(1,i).forager_count);
end
%Calculate flower activity
flower_activity = zeros(1,obj.prop.Sim.eval_time_days);
for i = 1:4
    for j = 1:size(obj.prop.Sim.Flower(1, i).year_activity,2)
        flower_activity(obj.prop.Sim.Flower(1, i).year_activity(1,j))=flower_activity(obj.prop.Sim.Flower(1, i).year_activity(1,j)) + obj.prop.Sim.Flower(1, i).year_activity(2,j);
    end
end

%Calculate active patches
patches = zeros(1,obj.prop.Sim.eval_time_days);

for i = 1:size(obj.data.hives.day,2);
   patches(obj.data.hives.day(1,i).actual_day)=obj.data.hives.day(1,i).patches_total;
end

%Draw
    fig = figure('name',obj.prop.Sys.identifier);
    set(gcf,'PaperPositionMode','auto','PaperType','A4')
    set(fig, 'Position', [0 0 944 1024])
%Draw iterative Graph
    s(1) = subplot(4,1,1);
    plot(obj.data.hives.uncapped_brood,'r-','LineWidth', 2);
    xlim([0 obj.prop.Sim.eval_time_days])
    hold on
    plot(obj.data.hives.foragers,'g-','LineWidth', 2);
    plot(obj.data.hives.hive_bees,'b-','LineWidth', 2);
    plot(obj.data.hives.food_storage,'k-','LineWidth', 2);    
  %Add Graph Descriptions
    legend('Uncapped Brood','Forager Bees','Hive Bees','Stored Food')
    legend('Location','NorthWest')
    title('Hive Statistics')
    xlabel('days')
    ylabel('count / grams')
    
%Draw bee and food change  
    s(2) = subplot(4,1,2);
    area(bee_change,'FaceColor','b')
    hold on
    xlim([0 obj.prop.Sim.eval_time_days])
    area(food_change/10,'FaceColor','g')
    %Add Graph Descriptions
    title('Bee and Food Change')
    legend('Bee Change','Food Change')
    legend('Location','NorthWest')
    xlabel('days')
    ylabel('(bees or 10g)/day')
    
%Draw daily min/max of scouts and foragers
    s(3) = subplot(4,1,3);
    plot(scouts_min,'b-','LineWidth', 2)
    xlim([0 obj.prop.Sim.eval_time_days])
    hold on
    plot(scouts_max,'g-','LineWidth', 2)
    plot(foragers_min,'y-','LineWidth', 2)
    plot(foragers_max,'r-','LineWidth', 2)   
  %Add Graph Descriptions
    title('daily min/max of scouts and foragers')
    legend('Scouts min','Scouts max','Foragers min','Foragers max')
    legend('Location','NorthWest')
    xlabel('days')
    ylabel('bees')
    
%Draw Patches
    s(4) = subplot(4,1,4);
    plot(patches,'b-','LineWidth', 2)
    hold on
    plot(flower_activity*100,'g-','LineWidth', 2)
    xlim([0 obj.prop.Sim.eval_time_days])
  %Add Graph Descriptions
    title('Patches and Quality')
    legend('Patches','Flower Quality')
    legend('Location','NorthWest')
    xlabel('days')
    ylabel('count / %')
    
%Link all the x-axis    
    linkaxes( s, 'x')
%Save as A4 eps and matlab fig
    print(fig,obj.prop.Sys.identifier,'-depsc2');
    saveas(fig,obj.prop.Sys.identifier,'fig');
    

    
end

