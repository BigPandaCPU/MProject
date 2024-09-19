clear,clc,close all
stl_file = '../data/femur_ori.stl';
[vnew, fnew, n, name] = stlRead(stl_file);
figure
trisurf(fnew,vnew(:,1),vnew(:,2),vnew(:,3))
axis('equal')

% stl_out.faces=fnew;
% stl_out.vertices=vnew;
% stlWrite('femur_ori.stl',stl_out)       



figure
[vnew, fnew, meanedge, stdev]=remesher(vnew, fnew, 3, 5);
trisurf(fnew,vnew(:,1),vnew(:,2),vnew(:,3))
axis('equal')

stl_out.faces=fnew;
stl_out.vertices=vnew;
stlWrite('../data/femur_resample.stl',stl_out)        % Save to binary .stl

