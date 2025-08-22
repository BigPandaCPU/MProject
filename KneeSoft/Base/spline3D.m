function [XYZspline]=spline3D(xyz,nrpoints)

n=(1:size(xyz,1));
t=(1:((size(xyz,1)-1)/(nrpoints-1)):size(xyz,1));
xx = spline(n,xyz(:,1),t)';
yy = spline(n,xyz(:,2),t)';
zz = spline(n,xyz(:,3),t)';
XYZspline=[xx yy zz];
end