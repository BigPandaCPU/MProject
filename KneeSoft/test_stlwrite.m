% clear,clc,close all
% [X,Y] = deal(1:40);             % Create grid reference
% Z = peaks(40);                  % Create grid height
% stlWrite('test.stl',X,Y,Z,'mode','ascii')
% 
% tmpvol = false(20,20,20);      % Empty voxel volume
% tmpvol(8:12,8:12,5:15) = 1;    % Turn some voxels on
% fv = isosurface(~tmpvol, 0.5); % Make patch w. faces "out"
% stlWrite('test2.stl',fv)        % Save to binary .stl


[x,y] = meshgrid(1:15,1:15);
tri = delaunay(x,y);
z = peaks(15);
trimesh(tri,x,y,z)