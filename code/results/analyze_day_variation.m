function analyze_day()

    select_day = 12;

    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    for i = 1 : 4
        for j = 1 : 5
            idx = i+(j-1)*4;
            load(strcat('Properties_Base_R',num2str(2),'_',num2str(i),'_',num2str(j),'_report.mat'));
            patches(idx,:) = obj.data.hives(1).day(select_day).patches_discovered/obj.data.hives(1).day(select_day).patches_total;
            food_sum(idx,:) = obj.data.hives(1).day(select_day).food_sum/max(obj.data.hives(1).day(select_day).food_sum);
            scouts(idx,:) = obj.data.hives(1).day(select_day).scouts_count/max(obj.data.hives(1).day(select_day).scouts_count);
            foragers(idx,:) = obj.data.hives(1).day(select_day).forager_count/max(obj.data.hives(1).day(select_day).forager_count);
            for k=2:48
                food_diff(idx,k)= (food_sum(idx,k)-food_sum(idx,k-1));
            end
        end
    end
    
    fig = figure();
    
    
    subplot(5,1,1)
    mean = (1/20)*sum(patches);
    var = (1/(20-1)) .* sum((patches-ones(20,1)*mean).^2);
    errorbar(1:4:48,mean(1:4:48),sqrt(var(1:4:48)),'xr','LineWidth',2,'Color',[0, 0, 1]);
    hold on
    plot(1:48,mean,'r-','LineWidth',2,'Color',[0, 0, 1]);
    grid on
    legend('standard deviation','patches discoverd');
    legend('Location','NorthEastOutside')
    xlabel('time')
    ylabel('percent')
    xlim([1 48])
    set(gca,'XTickLabel',{'9:15','10:30','11:45','13:00','14:15','15:30','16:45','18:00','19:15','20:30'});

             
    subplot(5,1,2)
    
    mean = (1/20)*sum(food_sum);
    var = (1/(20-1)) .* sum((food_sum-ones(20,1)*mean).^2);
    errorbar(1:4:48,mean(1:4:48),sqrt(var(1:4:48)),'x','LineWidth',2,'Color',[0, 0.5, 0]);
    hold on
    plot(1:48,mean,'r-','LineWidth',2,'Color',[0, 0.5, 0]);
    grid on
    legend('standard deviation','food collected');
    legend('Location','NorthEastOutside')
    xlabel('time')
    ylabel('percent')
    xlim([1 48])
    set(gca,'XTickLabel',{'9:15','10:30','11:45','13:00','14:15','15:30','16:45','18:00','19:15','20:30'});
    
    subplot(5,1,3)
    
    mean = (1/20)*sum(scouts);
    var = (1/(20-1)) .* sum((scouts-ones(20,1)*mean).^2);
    errorbar(1:4:48,mean(1:4:48),sqrt(var(1:4:48)),'x','LineWidth',2,'Color',[1, 0, 0]);
    hold on
    plot(1:48,mean,'r-','LineWidth',2,'Color',[1, 0, 0]);
    grid on
    legend('standard deviation','scout bees');
    legend('Location','NorthEastOutside')
    xlabel('time')
    ylabel('percent')
    xlim([1 48])
    set(gca,'XTickLabel',{'9:15','10:30','11:45','13:00','14:15','15:30','16:45','18:00','19:15','20:30'});
    
    subplot(5,1,4)
    
    mean = (1/20)*sum(foragers);
    var = (1/(20-1)) .* sum((foragers-ones(20,1)*mean).^2);
    errorbar(1:4:48,mean(1:4:48),sqrt(var(1:4:48)),'x','LineWidth',2,'Color',[0, 0.75, 0.75]);
    hold on
    plot(1:48,mean,'r-','LineWidth',2,'Color',[0, 0.75, 0.75]);
    grid on
    legend('standard deviation','forager bees');
    legend('Location','NorthEastOutside')
    xlabel('time')
    ylabel('percent')
    xlim([1 48])
    set(gca,'XTickLabel',{'9:15','10:30','11:45','13:00','14:15','15:30','16:45','18:00','19:15','20:30'});
    
    subplot(5,1,5)
    
    mean = (1/20)*sum(food_diff);
    var = (1/(20-1)) .* sum((food_diff-ones(20,1)*mean).^2);
    errorbar(1:4:48,mean(1:4:48),sqrt(var(1:4:48)),'x','LineWidth',2,'Color',[0.75, 0, 0.75]);
    hold on
    plot(1:48,mean,'r-','LineWidth',2,'Color',[0.75, 0, 0.75]);
    grid on
    legend('standard deviation','food change');
    legend('Location','NorthEastOutside')
    xlabel('time')
    ylabel('percent')
    xlim([1 48])
    set(gca,'XTickLabel',{'9:15','10:30','11:45','13:00','14:15','15:30','16:45','18:00','19:15','20:30'});

    actual_day = obj.data.hives(1).day(select_day).actual_day;
% 
% 
      
%     fig = figure('name',strcat('Properties_Base_R1_1_day',num2str(actual_day)));
     set(gcf,'PaperPositionMode','auto','PaperType','A4')
     set(fig, 'Position', [0 0 944 1024])
     %fig = figure();

%     %Draw iterative Graph
     %set(gca,'FontSize',12);
%     plot(transp(plot_data),'-','LineWidth', 2);
     %ylim([0 1])
%     %Add Graph Descriptions
%     title(strcat('day ',num2str(actual_day)))

% 
%     %Save as A4 eps and matlab fig
     print(strcat('Properties_Base_R2_variation_day',num2str(actual_day)),'-depsc2');
     saveas(fig,strcat('Properties_Base_R2_variation_day',num2str(actual_day)),'fig');

     corr(sum(patches)',sum(food_diff)')
     corr(sum(foragers)',sum(food_diff)')
     corr(sum(scouts)',sum(food_diff)')
end

