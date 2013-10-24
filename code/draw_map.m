function [ output_args ] = draw_map( Prop, type_map, quality_map )
%DRAW_MAP Summary of this function goes here
%   Detailed explanation goes here
hsv_image_map = ones(Prop.Sim.world_size/10,Prop.Sim.world_size/10,3);
hsv_image_map(:,:,1) = type_map.array/6;
hsv_image_map(:,:,3) = quality_map.array;
image_map = hsv2rgb(hsv_image_map);
image_map = min(image_map,1);
image_map = max(image_map,0);
image(image_map)




end

