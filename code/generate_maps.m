function [type_map,quality_map,maxquality_map] = generate_maps(Prop)
%GENERATE_FLOWERMAP Generates a map from a png file.
%   creates a 1000x1000 map with 0:4 values, 4:1 for rbgk and 0 for
%   anything else.

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
    %scale the values of h to 0:6
    tic
    type_map.array = round(mod((type_map.array)*6,6));
    toc
%--------------------------------------------------------
%old iterative version    
%         %round the hue values to multiples of 1/6
%         tic
%          for x = 1:Prop.Sim.world_size/10
%              for y = 1:Prop.Sim.world_size/10
%                  if type_map.array(x,y) <= 1/12
%                      type_map.array(x,y) = 0;
%                  elseif type_map.array(x,y) <= 3/12
%                      type_map.array(x,y) = 1/6;
%                  elseif type_map.array(x,y) <= 5/12
%                      type_map.array(x,y) = 2/6;
%                  elseif type_map.array(x,y) <= 7/12
%                      type_map.array(x,y) = 3/6;
%                  elseif type_map.array(x,y) <= 9/12
%                      type_map.array(x,y) = 4/6;
%                  elseif type_map.array(x,y) <= 11/12
%                      type_map.array(x,y) = 5/6;
%                  else
%                      type_map.array(x,y) = 0;
%                  end
%              end
%          end
%          toc
%         type_map.array = round(type_map.array.*6);
%--------------------------------------------------------

    figure
    imagesc(type_map.array);
end

