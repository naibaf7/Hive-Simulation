function bresenham_test()

    dim = 15;

    map = ones(dim,dim);

    x1 = 4;
    x2 = 12;
    y1 = 3;
    y2 = 14;

    [y,x] = bresenham(x1,y1,x2,y2);
    i = sub2ind([dim,dim],x,y);
    map(i) = 0;
    
    colormap(gray);
    imagesc(map);
    axis square
    hold on
    
    for i = 1:dim
        plot(i-0.5,1:0.1:dim,'k');
        hold on
        plot(1:0.1:dim,i-0.5,'k');
        hold on
    end
    
    fx = @(t) x1 + t*(x2-x1); 
    fy = @(t) y1 + t*(y2-y1);
    t = 0:0.01:1;
    plot(fx(t),fy(t),'b','LineWidth',4);
    hold on
    plot(x1,y1,'rx','MarkerSize',10,'LineWidth',3);
    hold on
    plot(x2,y2,'rx','MarkerSize',10,'LineWidth',3);


end

