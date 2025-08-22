function [FligPP, VligPP] = PatellarTendonBuilder(V,F,osteo,IndicesPatProx,IndicesPatDist,nr_patpoints,nrpoints,interpolationr,interpolationc)

%Spline interpolation for the contour of the Patellar tendon
pointsPat=V(IndicesPatProx,:);
[XYZsplinePat]=spline3D(pointsPat,nr_patpoints)';
IndicesPatProx = knnsearch(V, XYZsplinePat'); 
%Spline interpolation for the contour of the Patellar tendon
pointsSpine=V(IndicesPatDist,:); 
[XYZsplineTib]=spline3D(pointsSpine,nr_patpoints)';
IndicesPatDist = knnsearch(V, XYZsplineTib'); 

%Create the connection between the patella and the tibia
XYZtemp = ones((nrpoints*nr_patpoints),3); 
for i=1:nr_patpoints
    [XYZtemp(1+(nrpoints*(i-1)):nrpoints*i,:),~]=shortpathligament(osteo,V(IndicesPatProx(i,1),:),V(IndicesPatDist(i,1),:),nrpoints);
 end 

% Put together, first points are also the last points
V = [XYZtemp;XYZtemp(1:nrpoints,:)]; 

% Interpolate
[xx,yy,zz]=lig3D(V,nr_patpoints+1,interpolationr,interpolationc);

% reshape the new ligament
VligPP(:,1)=reshape(xx,prod(size(xx)),1);
VligPP(:,2)=reshape(yy,prod(size(xx)),1);
VligPP(:,3)=reshape(zz,prod(size(xx)),1);

%Create new triangulation matrix
FligPP = createEM(interpolationc,interpolationr);

% flip the normals
FligPP(:,4)=FligPP(:,2);
FligPP(:,2)=[]; 



end 