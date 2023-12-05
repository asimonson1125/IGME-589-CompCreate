function meatballs()
    % addpath('./savelib/')
    rand('seed', 1125);
    close all;
    disp("Sugma.");
    hold on;

    axis equal;
    grid off;
    axis off;

    set(gcf, 'Position', [100 100 1400 1400]);

    % Number of points to generate
    % numPoints = 200;
    numPoints = 500;
    % numPoints = 1000;

    numOuterPoints = 250;

    % Generate random angles
    theta = 2 * pi * rand(1, numPoints);
    phi = acos(2 * rand(1, numPoints) - 1);

    outertheta = 2 * pi * rand(1, numOuterPoints);
    outerphi = acos(2 * rand(1, numOuterPoints) - 1);

    % Convert spherical coordinates to Cartesian coordinates
    x = sin(phi) .* cos(theta);
    y = sin(phi) .* sin(theta);
    z = cos(phi);
    
    outerscale = 1.25;
    xo = sin(outerphi) .* cos(outertheta) * outerscale;
    yo = sin(outerphi) .* sin(outertheta) * outerscale;
    zo = cos(outerphi) * outerscale;


    % Plot the points on the sphere behind triangle
    color = [1 0 0];
    behindX = x(z < 0);
    behindY = y(z < 0);
    plot_streaks(behindX, behindY, color);
    scatter(behindX, behindY, 10, color, 'filled', 'SizeData', 10);
    plot_glow(behindX, behindY, color);

    outercolor = [0 0 1];
    behindXo = xo(zo < 0);
    behindYo = yo(zo < 0);
    plot_streaks(behindXo, behindYo, outercolor);
    scatter(behindXo, behindYo, 10, outercolor, 'filled', 'SizeData', 10);
    plot_glow(behindXo, behindYo, outercolor);

    % TRIANGLE SEGMENT
    triangleRadius = .9; % Adjust the radius of the triangle
    triangleAngle = linspace(0, 2 * pi, 4); % Three points for a triangle
    triangleX = triangleRadius * cos(triangleAngle);
    triangleY = triangleRadius * sin(triangleAngle);

    % Rotation matrix
    rotationAngle = -pi/2;
    R = [cos(rotationAngle), -sin(rotationAngle); sin(rotationAngle), cos(rotationAngle)];

    % Apply rotation to triangle vertices
    rotatedTriangle = R * [triangleX; triangleY];
    % rotatedTriangle = [triangleX; triangleY];

    % Plot the rotated triangle with opacity
    fill(rotatedTriangle(1, :), rotatedTriangle(2, :), 'k' , 'FaceAlpha', 0.75);

    % RECTANGLE LOOP
    % for rectNum = 1:3
    %     width = .05;
    %     baseypos = rectNum/3 - (1.73205/2);
    %     rectx = [0 rectNum*2 rectNum*2 0];
    %     recty = [(width/2)+baseypos, (width/2)+baseypos, -(width/2)+baseypos, -(width/2)+baseypos];

    %     % Plot rectangles without affecting the opacity of the triangle
    %     hRect = fill(rectx, recty, 'k');
    % end

    % % Plot the sphere dots in front of the triangle
    frontX = x(z >= 0);
    frontY = y(z >= 0);
    plot_streaks(frontX, frontY, color);
    scatter(frontX, frontY, 10, color, 'filled');
    plot_glow(frontX, frontY, color)

    frontXo = xo(zo >= 0);
    frontYo = yo(zo >= 0);
    plot_streaks(frontXo, frontYo, outercolor);
    scatter(frontXo, frontYo, 10, outercolor, 'filled');
    plot_glow(frontXo, frontYo, outercolor);

    set(gcf,'Color', [.2 .2 .2]);

    exportgraphics(gcf,'meatballs.png', 'Resolution', 500);
    exportgraphics(gcf,'vectorfig.pdf','ContentType','vector')
    exportgraphics(gcf,'vectorfig.eps','ContentType','vector')

end

function plot_glow(x, y, color)
    for sz = linspace(1000, 1, 9)
        alpha = .0025;
        scatter(x, y, sz, color, 'filled', 'MarkerEdgeAlpha', alpha, 'MarkerFaceAlpha', alpha, 'SizeData', sz);
    end
end

function plot_streaks(x, y, color)
    % Calculate the distance from each point to the center
    distanceToCenter = sqrt(sqrt(x.^2 + y.^2));

    % Length of the streaks (adjust as needed)
    color = [color .05];
    streakLength = .25;

    % Plot the points on the circle with streaks towards the center
    for i = 1:length(x)
        % Calculate the end point of the streak
        endX = x(i) - streakLength * x(i) * distanceToCenter(i);
        endY = y(i) - streakLength * y(i) * distanceToCenter(i);
        
        % Plot the streak
        plot([x(i), endX], [y(i), endY], 'color', color, 'LineWidth', 1);
    end
end
