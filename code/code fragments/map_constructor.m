function map = map_constructor(patch_count, patch_size, map_size, name)
    
    maxquality_map = zeros(map_size,map_size); 
    type_map = zeros(map_size,map_size);
    

    % Generate patches
    for i = 1:patch_count
        type = ceil(rand()*4);
        quality = abs(randn()*0.5);
        % Ensure disjunct patches
        r = round(abs(randn()*patch_size));
        y = randi([1+r,map_size-r],1);
        x = randi([1+r,map_size-r],1);
        ind = bwselect(logical(type_map),y-r:y+r,x-r:x+r);
        while(sum(sum(type_map(ind))) > 0)
            r = round(abs(randn()*patch_size));
            y = randi([1+r,map_size-r],1);
            x = randi([1+r,map_size-r],1);
            ind = bwselect(logical(type_map),y-r:y+r,x-r:x+r);
        end
        type_map(y-r:y+r,x-r:x+r) = type;
        maxquality_map(y-r:y+r,x-r:x+r) = quality;
    end
    
    imagesc(maxquality_map)
    
    zm = ones(map_size,map_size);
    
    map = zeros(map_size,map_size,3);
    
    map(:,:,1) = type_map/6;
    map(:,:,3) = maxquality_map;
    map(:,:,2) = zm;
    
    imwrite(hsv2rgb(map), strcat(name,'.png'), 'png');

end

