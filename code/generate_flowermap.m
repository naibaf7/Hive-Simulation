function flower_map = generate_flowermap(Prop)
%GENERATE_FLOWERMAP Generates a map from a png file.
%   creates a 1000x1000 map with 0:4 values, 4:1 for rbgk and 0 for
%   anything else.

    image = imread(Prop.Sim.world_file);
    size_image = size(image);

    %resize if necessary
    if  size_image(1:2) == Prop.Sim.world_size/10
    else
        image = imresize(image, [Prop.Sim.world_size/10,Prop.Sim.world_size/10]);
    end

    %initalize empty map
    flower_map = Map(0,Prop.Sim.world_size/10,Prop.Sim.world_size/10);
    %flower_map.array = zero(Prop.Sim.world_size/10);

    %fill map
    for x = 1:Prop.Sim.world_size/10
        for y = 1:Prop.Sim.world_size/10
            if image(x,y,1:3) == 255
                flower_map.array(x,y)=4;
            elseif image(x,y,1) == 255
                flower_map.array(x,y)=3;
            elseif image(x,y,2) == 255
                flower_map.array(x,y)=2;
            elseif image(x,y,1) == 255
                flower_map.array(x,y)=1;
            end                                
        end
    end
    
    figure
    imagesc(flower_map.array);
end

