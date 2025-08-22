function [V,F]=mergesurfaces(V1,F1,V2,F2)

M=max(F1);
F2=F2+M(1,1);
V=vertcat(V1,V2);
F=vertcat(F1,F2);
end