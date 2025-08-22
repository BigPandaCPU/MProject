function [Vlig,Flig,len]=LigamentBuilder(V,F,osteo,IndicesBone1,IndicesBone2,nrpoints,interpolationr,interpolationc)

% Compute three individual fibres of the ligaments
[XYZtemp1,cumDist1]=shortpathligament(osteo,V(IndicesBone1(1,1),:),V(IndicesBone2(1,1),:),nrpoints);
[XYZtemp2,cumDist2]=shortpathligament(osteo,V(IndicesBone1(2,1),:),V(IndicesBone2(2,1),:),nrpoints);
[XYZtemp3,cumDist3]=shortpathligament(osteo,V(IndicesBone1(3,1),:),V(IndicesBone2(3,1),:),nrpoints);

% Put the ligament fibers together
V=[XYZtemp1;XYZtemp2;XYZtemp3];
len=[cumDist1;cumDist2;cumDist3];

%Create new triangulation matrix
F = createEM(3,nrpoints);

% Interpolate
[xx,yy,zz] = lig3D(V,3,interpolationr,interpolationc);

% reshape the new ligament
Vlig(:,1)=reshape(xx,prod(size(xx)),1);
Vlig(:,2)=reshape(yy,prod(size(xx)),1);
Vlig(:,3)=reshape(zz,prod(size(xx)),1);

%Create new triangulation matrix
Flig = createEM(interpolationc,interpolationr);

end



