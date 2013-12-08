function random_walk()
    set(gca,'FontSize',14);
    alpha = rand()*2*pi;
    v = 7;
    scale = 0.5;
    w = zeros(2,1000);
    for i=1:1000
        if(mod((i-1),30) == 0)
            alpha = alpha+scale*randn();
        end
        w(1,i+1) = w(1,i) + cos(alpha)*v;
        w(2,i+1) = w(2,i) + sin(alpha)*v;
        plot(w(1,1:i),w(2,1:i),'LineWidth',2);
        xlabel('distance [m]');
        ylabel('distance [m]');
        pause(0.001);
    end
    pause(3);
    ax(1) = subplot(2,3,1);
    plot(ax(1),w(1,:),w(2,:),'LineWidth',2);
    xlabel(strcat(num2str(0),' optimizations'));
    axis square
    pause(1);
    for i=1:10;
        [~,old_n] = size(w);
        new_n = floor((old_n-2)/2)+2;
        nw = zeros(2,new_n);
        % copy every 2nd waypoint, preserve start and end point
        inserts = w(:,1:2:old_n-1);
        [~,ins_size] = size(inserts);
        nw(:,1:1:ins_size) = inserts;
        nw(:,new_n) = w(:,old_n);
        w = nw;
        if(mod(i,2) == 0)
            ax((i-2)/2+2) = subplot(2,3,(i-2)/2+2);
            plot(ax((i-2)/2+2),w(1,:),w(2,:),'LineWidth',2);
            xlabel(strcat(num2str(i),' optimizations'));
            axis square
        end
    end
    linkaxes(ax)
    pause(4);
end

