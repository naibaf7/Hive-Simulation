function [ output_args ] = analyze_day( obj )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
for i =1:53
plot_data(i,:,1) = obj.data.hives.day(1,i).patches_discovered/obj.data.hives.day(1,i).patches_total;
plot_data(i,:,2) = obj.data.hives.day(1,i).food_sum/max(obj.data.hives.day(1,i).food_sum);
plot_data(i,:,3) = obj.data.hives.day(1,i).scouts_count/max(obj.data.hives.day(1,i).scouts_count);
plot_data(i,:,4) = obj.data.hives.day(1,i).forager_count/max(obj.data.hives.day(1,i).forager_count);
legend_string{i} = strcat('day',num2str(obj.data.hives.day(1,i).actual_day));
end

fig = figure('name','Properties_Base_R1_1_days');
set(gcf,'PaperPositionMode','auto','PaperType','A4')
set(fig, 'Position', [0 0 944 1024])

%Draw iterative Graph
s(1) = subplot(4,1,1);
plot(transp(plot_data(:,:,1)),'-','LineWidth', 2);
xlim([1 48])
%Add Graph Descriptions
legend(legend_string')
legend('Location','NorthEast')
title('patches discovered')
xlabel('0.5 h')
ylabel('percent')

%Draw iterative Graph
s(2) = subplot(4,1,2);
plot(transp(plot_data(:,:,2)),'-','LineWidth', 2);
xlim([1 48])
%Add Graph Descriptions
title('food sum')
xlabel('0.5 h')
ylabel('percent')

%Draw iterative Graph
s(3) = subplot(4,1,3);
plot(transp(plot_data(:,:,3)),'-','LineWidth', 2);
xlim([1 48])
%Add Graph Descriptions
title('scout count')
xlabel('0.5 h')
ylabel('percent')

%Draw iterative Graph
s(4) = subplot(4,1,4);
plot(transp(plot_data(:,:,4)),'-','LineWidth', 2);
xlim([1 48])
%Add Graph Descriptions
title('forager count')
xlabel('0.5 h')
ylabel('percent')

%Save as A4 eps and matlab fig
print('Properties_Base_R1_1_days','-depsc2');
saveas(fig,'Properties_Base_R1_1_days','fig');

end

