function [ output_args ] = analyze_simulationrun( run_number,iteration_number, jteration_number )
%ANALYZE_SIMULATIONRUN Showcase for the team
%   Detailed explanation goes here
reports = cell(iteration_number, jteration_number) ;

for i = 1:iteration_number;
for j = 1:jteration_number;
    load(strcat('Properties_Base_R',num2str(run_number),'_',num2str(i),'_',num2str(j),'_report.mat'));
	analyze_report(obj);
    reports{i,j} = obj;
end
end
for i = 1:iteration_number;
	for j = 1:jteration_number;
    uncapped_brood{i,j}= reports{i,j}.data.hives.uncapped_brood;
    foragers{i,j}= reports{i,j}.data.hives.foragers;
    hive_bees{i,j}= reports{i,j}.data.hives.hive_bees;
    food_storage{i,j}= reports{i,j}.data.hives.food_storage;
	end
end
for i = 1:iteration_number;
%Draw
    fig = figure('name',strcat('Properties_Base_R',num2str(run_number),'_',num2str(i),'_i'));
    set(gcf,'PaperPositionMode','auto','PaperType','A4')
    set(fig, 'Position', [0 0 944 1024])
    %Perpare legend strings
    legend_string = cell(jteration_number,1);
    for j = 1:jteration_number;
        legend_string{j} = strcat('run ',num2str(j));
    end
    %make plot matrizes
    for j = 1:jteration_number
    plot_uncapped_brood(j,:)= cell2mat(uncapped_brood(i,j));
    plot_foragers(j,:)= cell2mat(foragers(i,j));
    plot_hive_bees(j,:)= cell2mat(hive_bees(i,j));
    plot_food_storage(j,:)= cell2mat(food_storage(i,j));
    end
%Draw Graphs 
    s(1) = subplot(4,1,1);
    plot(transp( plot_uncapped_brood),'LineWidth', 2)
    xlim([0 obj.prop.Sim.eval_time_days])
    title('uncapped brood')
    legend(legend_string) 
    
    s(2) = subplot(4,1,2);
    plot(transp( plot_foragers),'LineWidth', 2)
    title('foragers')
    xlim([0 obj.prop.Sim.eval_time_days])
    legend(legend_string) 
    
    s(3) = subplot(4,1,3);
    plot(transp( plot_hive_bees),'LineWidth', 2)
    title('hive bees')
    xlim([0 obj.prop.Sim.eval_time_days])
    legend(legend_string) 
    
    s(4) = subplot(4,1,4);
    plot(transp( plot_food_storage),'LineWidth', 2)
    title('Stored Food')
    xlim([0 obj.prop.Sim.eval_time_days])
    legend(legend_string)    
	%Link all the x-axis    
		linkaxes( s, 'x')
 
%Save as A4 eps and matlab fig
    print(strcat('Properties_Base_R',num2str(run_number),'_',num2str(i),'_i'),'-depsc2');
    saveas(fig,strcat('Properties_Base_R',num2str(run_number),'_',num2str(i),'_i'),'fig');
    
end
for i = 1:jteration_number;
%Draw
    fig = figure('name',strcat('Properties_Base_R',num2str(run_number),'_i','_',num2str(i)));
    set(gcf,'PaperPositionMode','auto','PaperType','A4')
    set(fig, 'Position', [0 0 944 1024])
    %Perpare legend strings
    legend_string = cell(iteration_number,1);
    for j = 1:iteration_number;
        legend_string{j} = strcat('run ',num2str(j));
    end
    %make plot matrizes
    for j = 1:iteration_number
    plot_uncapped_brood(j,:)= cell2mat(uncapped_brood(j,i));
    plot_foragers(j,:)= cell2mat(foragers(j,i));
    plot_hive_bees(j,:)= cell2mat(hive_bees(j,i));
    plot_food_storage(j,:)= cell2mat(food_storage(j,i));
    end
%Draw Graphs 
    s(1) = subplot(4,1,1);
    plot(transp( plot_uncapped_brood),'LineWidth', 2)
    xlim([0 obj.prop.Sim.eval_time_days])
    title('uncapped brood')
    legend(legend_string) 
    
    s(2) = subplot(4,1,2);
    plot(transp( plot_foragers),'LineWidth', 2)
    title('foragers')
    xlim([0 obj.prop.Sim.eval_time_days])
    legend(legend_string) 
    
    s(3) = subplot(4,1,3);
    plot(transp( plot_hive_bees),'LineWidth', 2)
    title('hive bees')
    xlim([0 obj.prop.Sim.eval_time_days])
    legend(legend_string) 
    
    s(4) = subplot(4,1,4);
    plot(transp( plot_food_storage),'LineWidth', 2)
    title('Stored Food')
    xlim([0 obj.prop.Sim.eval_time_days])
    legend(legend_string)    
	%Link all the x-axis    
		linkaxes( s, 'x')
 
%Save as A4 eps and matlab fig
    print(strcat('Properties_Base_R',num2str(run_number),'_i','_',num2str(i)),'-depsc2');
    saveas(fig,strcat('Properties_Base_R',num2str(run_number),'_i','_',num2str(i)),'fig');
    
end
end

