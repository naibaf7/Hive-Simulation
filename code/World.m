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
    end
    
    methods
        % Constructor
        function obj = World(Prop)
            obj.prop = Prop;
            n = Prop.Sim.world_size;
            obj.scent_map = Map(0, n/10, n/10);
            obj.smog_map = Map(0, n/10, n/10);
            [obj.type_map, obj.quality_map, obj.maxquality_map] = generate_maps(Prop);
        end
        
        function simulate_d(obj, t_d)
        end
        
        % Iterative simulation step
        function simulate_s(obj, t_s)
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
        
        function draw_s(obj)
            clf
            
            %spy(obj.scent_map_c.array);
            colormap('hot')
            imagesc(obj.scent_map.array);
            colorbar
        end
        
        function draw_d(obj)
        end
        
    end


end

