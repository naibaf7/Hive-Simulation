function analyze_food_variation()
       
    food_mat = zeros(20,240);

    for i = 1 : 4
        for j = 1 : 5

            load(strcat('Properties_Base_R',num2str(2),'_',num2str(i),'_',num2str(j),'_report.mat'));
            food_mat(i+(j-1)*4,:) = obj.data.hives(1).food_storage(1:240);
        end
    end
    
    fig = figure();
    set(gcf,'PaperPositionMode','auto','PaperType','A4')
    set(fig, 'Position', [0 0 944 400])
    mean = (1/20)*sum(food_mat);
    var = (1/(20-1)) .* sum((food_mat-ones(20,1)*mean).^2);
    errorbar(1:5:240,mean(1:5:240),sqrt(var(1:5:240)),'xr','LineWidth',2);
    hold on
    set(gca,'FontSize',12);
    plot(mean,'b-','LineWidth',2);
    xlim([1 240])
    legend('standard deviation','food collected (mean)')
    legend('Location','NorthWest')
    xlabel('days')
    ylabel('grams')
    grid on
    print('Properties_Base_R2_food_variation','-depsc2');
    saveas(fig,'Properties_Base_R2_food_variation','fig');
end