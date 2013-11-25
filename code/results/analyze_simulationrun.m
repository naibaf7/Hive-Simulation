function [ output_args ] = analyze_simulationrun( run_number,iteration_number, varargin )
%ANALYZE_SIMULATIONRUN Analyze a 1 or 2D simulation run.
%   Detailed explanation goes here

%1D to 2D completion
if size(varargin) <1
    jteration_number = 1;
else
    jteration_number = varargin{1};
end
%load report files
[uncapped_brood,foragers,hive_bees,food_storage,eval_time_days] = load_reports(run_number,iteration_number,jteration_number);

if jteration_number > 1;
    %wipeout old matrizes
    plot_uncapped_brood = zeros(jteration_number,eval_time_days);
    plot_foragers = zeros(jteration_number,eval_time_days);
    plot_hive_bees = zeros(jteration_number,eval_time_days);
    plot_food_storage = zeros(jteration_number,eval_time_days);
    for i = 1:iteration_number;        
        %make plot matrices
        for j = 1:jteration_number
            plot_uncapped_brood(j,:) = cell2mat(uncapped_brood(i,j));
            plot_foragers(j,:) = cell2mat(foragers(i,j));
            plot_hive_bees(j,:) = cell2mat(hive_bees(i,j));
            plot_food_storage(j,:) = cell2mat(food_storage(i,j));
        end
        
        %Prepare legend strings
        legend_string = generate_legend_string(jteration_number);
        
        %1.Draw for 2D simulation runs
        fig = draw_graphics(plot_uncapped_brood,plot_foragers,plot_hive_bees,plot_food_storage,legend_string,eval_time_days);
        set(fig,'name',strcat('Properties_Base_R',num2str(run_number),'_',num2str(i),'_i'));
        
        %Save as A4 eps and matlab fig
        save(fig,strcat('Properties_Base_R',num2str(run_number),'_',num2str(i),'_i'));
    end
    %wipeout old matrizes
    plot_uncapped_brood = zeros(iteration_number,eval_time_days);
    plot_foragers = zeros(iteration_number,eval_time_days);
    plot_hive_bees = zeros(iteration_number,eval_time_days);
    plot_food_storage = zeros(iteration_number,eval_time_days);
    
    for i = 1:jteration_number;
        
        %make plot matrices
        for j = 1:iteration_number
            plot_uncapped_brood(j,:)= cell2mat(uncapped_brood(j,i));
            plot_foragers(j,:)= cell2mat(foragers(j,i));
            plot_hive_bees(j,:)= cell2mat(hive_bees(j,i));
            plot_food_storage(j,:)= cell2mat(food_storage(j,i));
        end
        %Prepare legend strings
        legend_string = generate_legend_string(iteration_number);
        
        %2.Draw for 2D simulation runs
        fig = draw_graphics(plot_uncapped_brood,plot_foragers,plot_hive_bees,plot_food_storage,legend_string,eval_time_days);
        set(fig,'name',strcat('Properties_Base_R',num2str(run_number),'_i','_',num2str(i)));
        %Save as A4 eps and matlab fig
        save(fig,strcat('Properties_Base_R',num2str(run_number),'_i','_',num2str(i)));
    end
    
else
    %wipeout old matrizes
    plot_uncapped_brood = zeros(iteration_number,eval_time_days);
    plot_foragers = zeros(iteration_number,eval_time_days);
    plot_hive_bees = zeros(iteration_number,eval_time_days);
    plot_food_storage = zeros(iteration_number,eval_time_days);
    %make plot matrices
    for j = 1:iteration_number
        plot_uncapped_brood(j,:)= cell2mat(uncapped_brood(j,1));
        plot_foragers(j,:)= cell2mat(foragers(j,1));
        plot_hive_bees(j,:)= cell2mat(hive_bees(j,1));
        plot_food_storage(j,:)= cell2mat(food_storage(j,1));
    end
    
    %Prepare legend strings
    legend_string = generate_legend_string(iteration_number);
    
    %Draw for 1D simulation runs
    fig = draw_graphics(plot_uncapped_brood,plot_foragers,plot_hive_bees,plot_food_storage,legend_string,eval_time_days);
    set(fig,'name',strcat('Properties_Base_R',num2str(run_number)));
    
    %Save as A4 eps and matlab fig
    save(fig,strcat('Properties_Base_R',num2str(run_number)));
end
end

function  [fig] = draw_graphics(plot_uncapped_brood,plot_foragers,plot_hive_bees,plot_food_storage,legend_string,xlimit)

fig = figure();
set(gcf,'PaperPositionMode','auto','PaperType','A4')
set(fig, 'Position', [0 0 944 1024])
%Draw Graphs
s(1) = subplot(4,1,1);
plot(transp( plot_uncapped_brood),'LineWidth', 2)
xlim([0 xlimit])
title('uncapped brood')
legend(legend_string)

s(2) = subplot(4,1,2);
plot(transp( plot_foragers),'LineWidth', 2)
title('foragers')
xlim([0 xlimit])
legend(legend_string)

s(3) = subplot(4,1,3);
plot(transp( plot_hive_bees),'LineWidth', 2)
title('hive bees')
xlim([0 xlimit])
legend(legend_string)

s(4) = subplot(4,1,4);
plot(transp( plot_food_storage),'LineWidth', 2)
title('Stored Food')
xlim([0 xlimit])
legend(legend_string)
%Link all the x-axis
linkaxes( s, 'x')
for i=1:4
    grid(s(i), 'on');
end
end

function  [legend_string] = generate_legend_string(length)
legend_string = cell(length,1);
for j = 1:length;
    legend_string{j} = strcat('run ',num2str(j));
end
end

function [uncapped_brood,foragers,hive_bees,food_storage,eval_time_days] = load_reports(run_number,iteration_number,jteration_number)
%load report files
reports = cell(iteration_number,jteration_number);
for i = 1:iteration_number;
    if jteration_number ~=1;
        for j = 1:jteration_number;
            load(strcat('Properties_Base_R',num2str(run_number),'_',num2str(i),'_',num2str(j),'_report.mat'));
            analyze_report(obj);
            reports{i,j} = obj;
        end
    else
        load(strcat('Properties_Base_R',num2str(run_number),'_',num2str(i),'_report.mat'));
        analyze_report(obj);
        reports{i,1} = obj;
    end
end
eval_time_days = obj.prop.Sim.eval_time_days+1;
uncapped_brood = cell(iteration_number,jteration_number);
foragers = cell(iteration_number,jteration_number);
hive_bees = cell(iteration_number,jteration_number);
food_storage = cell(iteration_number,jteration_number);
for i = 1:iteration_number;
    for j = 1:jteration_number;
        uncapped_brood{i,j} = reports{i,j}.data.hives.uncapped_brood;
        foragers{i,j} = reports{i,j}.data.hives.foragers;
        hive_bees{i,j} = reports{i,j}.data.hives.hive_bees;
        food_storage{i,j} = reports{i,j}.data.hives.food_storage;
    end
end
end

function [] = save(fig,filename)
%Save as A4 eps and matlab fig
print(filename,'-depsc2');
saveas(fig,filename,'fig');
end
