function [ output_args ] = analyze_day( obj )


%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
plot_data(1,:) = obj.patches_discovered/obj.patches_total;
plot_data(2,:) = obj.food_sum/max(obj.food_sum);
plot_data(3,:) = obj.scouts_count/max(obj.scouts_count);
plot_data(4,:) = obj.forager_count/max(obj.forager_count);
for i=2:48
    plot_data(5,i)= 10*(plot_data(2,i)-plot_data(2,i-1));
end
actual_day = obj.actual_day;


fig = figure('name',strcat('Properties_Base_R1_1_day',num2str(actual_day)));
set(gcf,'PaperPositionMode','auto','PaperType','A4')
set(fig, 'Position', [0 0 944 400])

%Draw iterative Graph
set(gca,'FontSize',12);
plot(transp(plot_data),'-','LineWidth', 2);
xlim([1 48])
%Add Graph Descriptions
legend('patches discoverd','food collected','scout bees','forager bees','food collected change \cdot 10')
legend('Location','NorthEastOutside')
title(strcat('day ',num2str(actual_day)))
xlabel('time')
ylabel('percent')
grid on
set(gca,'XTickLabel',{'9:15','10:30','11:45','13:00','14:15','15:30','16:45','18:00','19:15','20:30'});

%Save as A4 eps and matlab fig
print(strcat('Properties_Base_R1_1_day',num2str(actual_day)),'-depsc2');
saveas(fig,strcat('Properties_Base_R1_1_day',num2str(actual_day)),'fig');

end

