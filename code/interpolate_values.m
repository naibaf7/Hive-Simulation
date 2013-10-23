function y = interpolate_values(xin, yin, xmin, xstep, xmax, ymin, ymax)
    % Interpolate values into vector
    % xin      1xN vector with x values
    % yin      1xN vector with y values
    % xmin     min. value for interpolation range
    % xstep    step between two interpolation points
    % xmax     max. value for interpolation range
    % ymin     low cap for y values
    % ymax     high cap for y values
    y = min(max(interp1(xin, yin, (xmin:xstep:xmax),'spline'),ymin),ymax);
end

