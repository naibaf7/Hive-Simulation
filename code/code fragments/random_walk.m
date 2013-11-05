function random_walk()
    alpha = rand()*2*pi;
    v = 7;
    scale = 0.5;
    w = zeros(2,10000);
    for i=1:10000
        if(mod((i-1),10) == 0)
            alpha = alpha+scale*randn();
        end
        w(1,i+1) = w(1,i) + cos(alpha)*v;
        w(2,i+1) = w(2,i) + sin(alpha)*v;
        plot(w(1,1:i),w(2,1:i));
        pause(0.001);
    end
    plot(w(1,:),w(2,:));
    for i=1:50;
        [~,old_n] = size(w);
        new_n = floor((old_n-2)/2)+2;
        nw = zeros(2,new_n);
        % copy every 2nd waypoint, preserve start and end point
        inserts = w(:,1:2:old_n-1);
        [~,ins_size] = size(inserts);
        nw(:,1:1:ins_size) = inserts;
        nw(:,new_n) = w(:,old_n);
        w = nw;
        plot(w(1,:),w(2,:));
        pause(1);
    end
end

