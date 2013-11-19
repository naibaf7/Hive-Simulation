function [ output_args ] = analyze_simulationrun( run_number,iteration_number )
%ANALYZE_SIMULATIONRUN Showcase for the team
%   Detailed explanation goes here

reports = [];
for i = 1:iteration_number;
    load(strcat('Properties_Base_R',num2str(run_number),'_',num2str(i),'_report.mat'));
    reports = [reports, obj];
end
for i = 1:iteration_number;
    uncapped_brood(i,:)= reports(i).data.hives.uncapped_brood(:);
    foragers(i,:)= reports(i).data.hives.foragers(:);
    hive_bees(i,:)= reports(i).data.hives.hive_bees(:);
    food_storage(i,:)= reports(i).data.hives.food_storage(:);
end
%Draw
    fig = figure('name',obj.prop.Sys.identifier);
    set(gcf,'PaperPositionMode','auto','PaperType','A4')
    set(fig, 'Position', [0 0 944 1024])
%Draw iterative Graph
    s(1) = subplot(4,1,1);
    plot(transp(uncapped_brood),'LineWidth', 2);
    xlim([0 obj.prop.Sim.eval_time_days])
    s(2) = subplot(4,1,2);
    plot(transp(foragers),'LineWidth', 2);
    xlim([0 obj.prop.Sim.eval_time_days])
    s(3) = subplot(4,1,3);
    plot(transp(hive_bees),'b-','LineWidth', 2);
    xlim([0 obj.prop.Sim.eval_time_days])
    s(4) = subplot(4,1,4);
    plot(transp(food_storage),'LineWidth', 2); 
    xlim([0 obj.prop.Sim.eval_time_days])
    
%Link all the x-axis    
    linkaxes( s, 'x')
%Save as A4 eps and matlab fig
    print(strcat('Properties_Base_R',num2str(run_number)),'-depsc2');
    saveas(fig,strcat('Properties_Base_R',num2str(run_number)),'fig');
    

end

