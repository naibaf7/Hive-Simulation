function [ output_args ] = draw_map( Prop, type_map, quality_map )
%DRAW_MAP draws an image of the map
%   type_map is the H matrix, and quality_map is the V matrix

%initialize image matrix
hsv_image_map = ones(Prop.Sim.world_size/10,Prop.Sim.world_size/10,3);

%fill it with the given values
hsv_image_map(:,:,1) = type_map.array/6;
hsv_image_map(:,:,3) = quality_map.array;

%convert hsv2rgb
image_map = hsv2rgb(hsv_image_map);

%correct 'rounding errors' from hsv2rgb
image_map = min(max(image_map,0),1);

%display image
image(image_map)




end

