classdef World < handle

    properties
        prop;
        % map with scent distribution, dimensions N/10 x N/10
        scent_map
        smog_map
        % map with flowers, smog source, dimensions N/10 x N/10
        type_map
        % map with flower quality, smog emission intensity, N/10 x N/10
        % current state
        quality_map
        % peak state
        maxquality_map
        % Flower vitality, 365 values, 4 flowers
        flower;
        % 
    end
    
    methods
        % Constructor
        function obj = World(Prop)
            obj.prop = Prop;
            n = Prop.Sim.world_size;
            obj.scent_map = Map(0, n/10, n/10);
            obj.smog_map = Map(0, n/10, n/10);
            [obj.type_map, obj.quality_map, obj.maxquality_map] = generate_maps(Prop);
            
            % Convert time area vector from properties (2xN) to 1x365 values for the year and cancel out negative values:
            obj.flower(1).year_activity = zeros(1,365);
            obj.flower(1).year_activity(Prop.Sim.Flower(1).year_activity(1,:)) = max(Prop.Sim.Flower(1).year_activity(2,:),0);
            obj.flower(2).year_activity = zeros(1,365);
            obj.flower(2).year_activity(Prop.Sim.Flower(2).year_activity(1,:)) = max(Prop.Sim.Flower(2).year_activity(2,:),0);
            obj.flower(3).year_activity = zeros(1,365);
            obj.flower(3).year_activity(Prop.Sim.Flower(3).year_activity(1,:)) = max(Prop.Sim.Flower(3).year_activity(2,:),0);
            obj.flower(4).year_activity = zeros(1,365);
            obj.flower(4).year_activity(Prop.Sim.Flower(4).year_activity(1,:)) = max(Prop.Sim.Flower(4).year_activity(2,:),0);
            
            % Looking if this is similar to P. 45 "Wisdom of the Hive", for
            % debug purposes ONLY:
%             bar(obj.flower(1).year_activity*Prop.Sim.Flower(1).peak);
%             hold on
%             bar(obj.flower(2).year_activity*Prop.Sim.Flower(2).peak);
%             hold on
%             bar(obj.flower(3).year_activity*Prop.Sim.Flower(3).peak);
%             hold on
%             bar(obj.flower(4).year_activity*Prop.Sim.Flower(4).peak);
%             pause(100);
        end
        
        function simulate_d(obj, t_d)
            update_quality_maps(obj, t_d);
        end
        
        function update_quality_maps(obj, t_d)
            % Write current quality depending on flower type and time of
            % the year
            n = obj.prop.Sim.world_size/10;
            obj.quality_map.array = zeros(n,n);
            i = find(obj.type_map.array==1);
            obj.quality_map.array(i) = obj.quality_map.array(i) + obj.maxquality_map.array(i) * obj.flower(1).year_activity(mod(t_d - 1, 365) + 1);
            i = find(obj.type_map.array==2);
            obj.quality_map.array(i) = obj.quality_map.array(i) + obj.maxquality_map.array(i) * obj.flower(2).year_activity(mod(t_d - 1, 365) + 1);
            i = find(obj.type_map.array==3);
            obj.quality_map.array(i) = obj.quality_map.array(i) + obj.maxquality_map.array(i) * obj.flower(3).year_activity(mod(t_d - 1, 365) + 1);
            i = find(obj.type_map.array==4);
            obj.quality_map.array(i) = obj.quality_map.array(i) + obj.maxquality_map.array(i) * obj.flower(4).year_activity(mod(t_d - 1, 365) + 1);
            
        end
        
        % Iterative simulation step
        function simulate_s(obj, t_s)

        end
        
        function update_diffusion(obj, t_s)
            n = obj.prop.Sim.world_size;     
            obj.scent_map.array(n/2,n/2) = 10;
            rate = 0.1;
            tic
            bottom = [obj.scent_map.array(2:end,:); obj.scent_map.array(1,:)];
            top = [obj.scent_map.array(end,:);obj.scent_map.array(1:(end-1),:)];
            right = [obj.scent_map.array(:,2:end), obj.scent_map.array(:,1)];
            left = [obj.scent_map.array(:,end),obj.scent_map.array(:,1:(end-1))];
            obj.scent_map.array = rate*obj.scent_map.array(:,:) + (1-rate) * (top(:,:) + bottom(:,:) + left(:,:) + right(:,:)) / 4;           
            toc
        end
        
        function draw_map(obj)
            %flush
            clf
            %initialize image matrix
            hsv_image_map = ones(obj.prop.Sim.world_size/10,obj.prop.Sim.world_size/10,3);

            %fill it with the given values
            hsv_image_map(:,:,1) = obj.type_map.array/6;
            hsv_image_map(:,:,3) = obj.quality_map.array;

            %convert hsv2rgb
            image_map = hsv2rgb(hsv_image_map);

            %correct 'rounding errors' from hsv2rgb
            image_map = min(max(image_map,0),1);

            %display image
            image(image_map)
            %handle = gcf;
            pause(0.01);
        end
        
        function draw_s(obj)
            clf
            
            %spy(obj.scent_map_c.array);
            colormap('hot')
            imagesc(obj.scent_map.array);
            colorbar
        end
        
        function draw_d(obj)
            draw_map(obj);
        end
        
    end


end

