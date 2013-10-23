function f = interpolate_function(xin, yin, degree, ymin, ymax)
    % Interpolate values into function handle
    % xin      1xN vector with x values
    % yin      1xN vector with y values
    % degree   polynom degree (must be smaller than N)
    % ymin     low cap for y values
    % ymax     high cap for y values
    [a,~,mu] = polyfit(xin,yin,degree);
    f = @(x) min(max(polyval(a, (x-mu(1))/mu(2)),ymin),ymax);
end

