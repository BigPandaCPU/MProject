function [xxx,yyy,zzz] = lig3D(V,nrpoints,rowsLigTex,colLigTex)

[r,c]=size(V);
X=reshape(V(:,1),r/nrpoints,nrpoints);
Y=reshape(V(:,2),r/nrpoints,nrpoints);
Z=reshape(V(:,3),r/nrpoints,nrpoints);

n=(1:nrpoints);

factorrows=(nrpoints-1)/(rowsLigTex-1);
trows=(1:factorrows:nrpoints);

factorcols=(r/nrpoints-1)/(colLigTex-1);
tcols=(1:factorcols:(r/nrpoints));

c=r/nrpoints;
for i=1:c
    x=vertcat(X(i,:)');
    y=vertcat(Y(i,:)');
    z=vertcat(Z(i,:)');

    xx(i,:) = spline(n,x,trows);
    yy(i,:) = spline(n,y,trows);
    zz(i,:) = spline(n,z,trows);
end

n=(1:(r/nrpoints));
for i=1:rowsLigTex
    x=xx(:,i)';
    y=yy(:,i)';
    z=zz(:,i)';

    xxx(:,i) = spline(n,x,tcols);
    yyy(:,i) = spline(n,y,tcols);
    zzz(:,i) = spline(n,z,tcols);
end

end