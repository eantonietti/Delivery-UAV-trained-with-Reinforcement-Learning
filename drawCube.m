function drawCube(x, y, z, color)
    vertices = [
        x, y, z;
        x+1, y, z;
        x+1, y+1, z;
        x, y+1, z;
        x, y, z+1;
        x+1, y, z+1;
        x+1, y+1, z+1;
        x, y+1, z+1
    ];
    
    faces = [
        1, 2, 3, 4;
        1, 2, 6, 5;
        2, 3, 7, 6;
        3, 4, 8, 7;
        4, 1, 5, 8;
        5, 6, 7, 8
    ];
    
    patch('Faces', faces, 'Vertices', vertices, 'FaceColor', color, 'EdgeColor', 'k', 'FaceAlpha', 0.5);
end
