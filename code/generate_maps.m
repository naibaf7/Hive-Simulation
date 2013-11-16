function [type_map,quality_map,maxquality_map] = generate_maps(Prop)
%   Generates a map from a png file.
%   creates a 1000x1000 map with 0:4 values, 4:1 for rbgk and 0 for
%   anything else.

% When drawing in GIMP, choose for H value:
% 330-360 and 0-30: Nothing     MEAN: 0
% 30-90: Flower 1               MEAN: 60
% 90-150: Flower 2              MEAN: 120
% 150-210: Flower 3             MEAN: 180
% 210-270: Flower 4             MEAN: 240
% 270-330: Smog                 MEAN: 300
% for S, choose 100, for V choose quality between 0 and 100%


    image = imread(Prop.Sim.world_file);
    image = rgb2hsv(image);
    size_image = size(image);

    %resize if necessary
    if  size_image(1:2) == Prop.Sim.world_size/10
    else
        image = imresize(image, [Prop.Sim.world_size/10,Prop.Sim.world_size/10]);
    end

    %initalize empty maps
    type_map = Map(0,Prop.Sim.world_size/10,Prop.Sim.world_size/10);
    quality_map = Map(0,Prop.Sim.world_size/10,Prop.Sim.world_size/10);
    maxquality_map = Map(0,Prop.Sim.world_size/10,Prop.Sim.world_size/10);
    
    %fill arrays
    type_map.array = image(:,:,1);
    maxquality_map.array = image(:,:,3);
    %scale the values of h to 0:5
    type_map.array = round(mod((type_map.array)*6,6));

    % Use this in debug mode to test if the map has been read correctly:
    %figure
    %imagesc(type_map.array);
    %colormap(hsv);
end

