function My_Logo_File()
    WIP = false; % if true, shows image in background.  If not, saves as eps
    close all;
    hold on;

    % if (WIP)
    %     grid on;
    %     im  = imread( 'thing.jpg' );
    %     imagesc( im );
    % end

    axis equal;

    border(500, 25); % quarter-inch divots, meaning this is for 5 inch cubes (technically 5 1/4" cuz board thickness)
    % border_outline(500);

    centerCirc()

    for angle = 0 : 90 : 359
        rotMat = [ cosd( angle ),  -sind( angle ),  0  ; ...
                    sind( angle ),  cosd( angle ),  0  ;];

        leaf(rotMat, 0)
        circ(rotMat)
        arrow(rotMat)
    end

    for angle = 45 : 90 : 359
        rotMat = [ cosd( angle ),  -sind( angle ),  0  ; ...
                    sind( angle ),  cosd( angle ),  0  ;];

        leaf(rotMat, -25);
        arrowPair(rotMat);
    end

    if (~WIP)
        grid off;
        axis off;
        % exportgraphics(gcf,'out.pdf','ContentType','vector')
        exportgraphics(gcf,'bottomtop.pdf','ContentType','vector')
    else
        % ax = gca;
        % ax.XLim = [210 290];
        % ax.YLim = [125 160];
    
        % ginput()
    end
end

function border(dimensions, divots)
    strokeWidth = 0.5;
    half = divots / 2;
    coords = [
        half half;
        half (divots*3);
        -half (divots*3);
        -half (divots*4);
        half (divots*4);
        half dimensions-(divots*3);
        -half dimensions-(divots*3);
        -half dimensions-(divots*2);
        half dimensions-(divots*2);
        half dimensions-half;
    ];
    xs = coords(:,1);
    ys = coords(:,2);

    plot(xs, ys, 'k-', 'lineWidth', strokeWidth);
    xs = -1*xs + dimensions;
    ys = -1*ys + dimensions;
    plot(xs, ys, 'k-', 'lineWidth', strokeWidth);
    xs = ys;
    ys = coords(:,1);
    plot(xs, ys, 'k-', 'lineWidth', strokeWidth);
    ys = -1*coords(:,1) + dimensions;
    xs = -1*xs +dimensions;
    plot(xs, ys, 'k-', 'lineWidth', strokeWidth);
end

function border_outline(dimensions)
    strokeWidth = 0.5;
    coords = [
        0 0;
        0 dimensions;
    ];
    xs = coords(:,1);
    ys = coords(:,2);

    plot(xs, ys, 'r-', 'lineWidth', strokeWidth);
    xs = -1*xs + dimensions;
    plot(xs, ys, 'r-', 'lineWidth', strokeWidth);
    xs = ys;
    ys = coords(:,1);
    plot(xs, ys, 'r-', 'lineWidth', strokeWidth);
    ys = -1*coords(:,1) + dimensions;
    plot(xs, ys, 'r-', 'lineWidth', strokeWidth);
end

function stem(rotmat, y_displacement)
    strokeWidth = 0.5;
    coords = [  
        250  153.7217
        247.1946  152.9977
        246.4706  149.7398
        241.9457  149.9208
        235.9729  150.2828
        232.8959  139.6041
        226.9231  137.7941
        224.2081  132.5452
        220.9502  130.0113
        219.5023  134.5362
        222.2172  143.9480
        228.1900  144.5000
        231.4480  154.6267
        238.5068  155.1697
        241.5837  154
        243.9367  156
        250  160
        ];
    % plot(coords(:,1), coords(:,2), 'bo'); % debugger for points
    coords(:,2) = coords(:,2) +1;
    flippedx = flip(((250 - coords(:,1)) + 250));
    flippedx(1,:) = [];
    flippedy = flip(coords(:,2));
    flippedy(1,:) = [];
    x = [coords(:,1); flippedx];
    y = [coords(:,2); flippedy];
    x = transpose(x);
    y = transpose(y) - y_displacement;
    sp1 = csape(1:numel(x), [x; y], 'periodic');
    yy1 = fnval(sp1, linspace(1, numel(x), 1000));
    yy1 = ((transpose(yy1) - 250) * rotmat) + 250;
    x = yy1(:,1);
    y = yy1(:,2);
    plot(x, y, 'k-', 'lineWidth', strokeWidth);
end

function arrow(rotmat)
    strokeWidth = 0.5;
    scale = 2;
    x = [-3 0 3 5 0 -5 -3];
    y = [0 5 0 0 15 0 0];
    sp1 = csape(1:numel(x), [x; y], 'periodic');
    yy1 = fnval(sp1, linspace(1, numel(x), 1000));

    x = yy1(1,:) * scale;
    y = yy1(2,:) * scale + 50;
    coords = transpose([x;y]) * rotmat;
    x = coords(:,1) + 250;
    y = coords(:,2) + 250;
    plot(x, y, 'k-', 'lineWidth', strokeWidth);
end

function arrowPair(rotmat)
    strokeWidth = 0.5;
    scale = 1.8;
    x = [-3 0 3 5 0 -5 -3];
    y = [0 5 0 0 15 0 0];
    sp1 = csape(1:numel(x), [x; y], 'periodic');
    yy1 = fnval(sp1, linspace(1, numel(x), 1000));

    x = yy1(1,:) * scale;
    y = yy1(2,:) * scale + 30;
    x1 = x - 12.5;
    x2 = x + 12.5;
    coords1 = transpose([x1;y]) * rotmat;
    coords2 = transpose([x2;y]) * rotmat;
    x1 = coords1(:,1) + 250;
    y1 = coords1(:,2) + 250;
    x2 = coords2(:,1) + 250;
    y2 = coords2(:,2) + 250;
    plot(x1, y1, 'k-', 'lineWidth', strokeWidth);
    plot(x2, y2, 'k-', 'lineWidth', strokeWidth);
end

function circ(rotMatrix)
    strokeWidth = 0.5;
    for side = [1 -1]
        for angle = 0 : 45 : 359
            rotMat = [ cosd( angle ),  -sind( angle ); ...
                        sind( angle ),  cosd( angle );];
            coords = plot_ellipse(7.5, 1, .5, 90);
            xs = coords(1,:);
            ys = coords(2,:) + 17.5;
            coords = transpose([xs;ys]);
            coords = coords * rotMat;
            coords = transpose(coords);
            xs = coords(1,:) + (67.5 * side);
            ys = coords(2,:) + 406 - 250;
            coords = transpose([xs;ys]);
            coords = coords * rotMatrix;
            xs = coords(:,1) + 250;
            ys = coords(:,2) + 250;
            plot(xs, ys, 'k-', 'lineWidth', strokeWidth);
        end
    end
end

function centerCirc()
    strokeWidth = 0.5;
    for side = [1 -1]
        for angle = 0 : 45 : 359
            rotMat = [ cosd( angle ),  -sind( angle ); ...
                        sind( angle ),  cosd( angle );];
            coords = plot_ellipse(7.5, 1, .5, 90);
            xs = coords(1,:);
            ys = coords(2,:) + 17.5;
            coords = transpose([xs;ys]);
            coords = coords * rotMat;
            coords = transpose(coords);
            xs = coords(1,:) + 250;
            ys = coords(2,:) + 250;
            plot(xs, ys, 'k-', 'lineWidth', strokeWidth);
        end
    end
end

function leaf(rotmatrix, y_displacement)
    stem(rotmatrix, y_displacement);
    strokeWidth = 0.5;
    % Stem
    % coords = plot_quadratic()
    % for 

    % Big Center Leaf
    coords = plot_ellipse(20, 1, .3, 90);
    xs = coords(1,:);
    ys = coords(2,:) + 400 + y_displacement - 250;
    coords = transpose([xs;ys]);
    coords = (coords * rotmatrix);
    xs = coords(:,1) + 250;
    ys = coords(:,2) + 250;
    plot(xs, ys, 'k-', 'lineWidth', strokeWidth);
    % fill(xs, ys, [1 1 1]); 

    % Leaf End
    coords = plot_ellipse(12, 1, .4, 90);
    xs = coords(1,:);
    ys = coords(2,:) + 469 + y_displacement - 250;
    coords = transpose([xs;ys]);
    coords = (coords * rotmatrix);
    xs = coords(:,1) + 250;
    ys = coords(:,2) + 250;
    plot(xs, ys, 'k-', 'lineWidth', strokeWidth);

    % Leaf Pairs
    % [x displacement, y displacement, angle, minor]
    pairs = [18, -28, 20, .55; ...
             19, -12, 25, .60; ....
             19, 5, 25, .55; ...
             18.5, 22, 25, .55; ...
             15, 39, 42.5, .4; ...
             11, 53, 45, .4];
    for leaflet = 1:6
        for side = [1, -1]
            coords = plot_ellipse(10-(leaflet*.25), 1, pairs(leaflet, 4), pairs(leaflet, 3)*side);
            xs = coords(1,:) + pairs(leaflet, 1) * side;
            ys = coords(2,:) + 400 + y_displacement - 250 + pairs(leaflet, 2);
            coords = transpose([xs;ys]);
            coords = (coords * rotmatrix);
            xs = coords(:,1) + 250;
            ys = coords(:,2) + 250;
            plot(xs, ys, 'k-', 'lineWidth', strokeWidth);
        end
    end
end

function coords = plot_ellipse(scale, major, minor, angle)
    thetas          = (0 : .1 : 360);
    % Make Ellipse
    xyhs            = [ major * cosd( thetas) ;
                        minor * sind( thetas) ];

    % Rotations
    rot_mat         = [ cosd( angle ),  -sind( angle );
                        sind( angle ),  cosd( angle )];
    uvhs            = rot_mat * xyhs * scale;

    xs = uvhs(1,:);
    ys = uvhs(2,:);

    coords = [xs; ys];


    % plot(xs, ys, 'k-', 'lineWidth', 1);
    % fill(xs, ys, color); 

end
