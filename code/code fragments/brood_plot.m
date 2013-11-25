function  brood_plot()

            laying_function = [-30,1,32,60,91,121,153,182,213,244,274,305,335,366,395;0.1,0.1,0.1,0.1,0.5,1,2,2,1,0.5,0.1,0.1,0.1,0.1,0.1];
            laying_rate = 2000;
            
            
            L_year_x = laying_function(1,:);
            
            % Load y values of measure points for laying rate change
            L_year_y = laying_function(2,:);
            
            % Interpolate values of laying rate change for 365 days
            L_year = interpolate_values(L_year_x,L_year_y,1,1,365,0,1);
            
            plot(L_year*laying_rate,'linewidth',2);
            
            xlabel('1 year (t) [d]');
            ylabel('L(t) (amount of eggs)');
            axis([0 365 0 2200]);
            grid on
            %legend('amount');


            

end

