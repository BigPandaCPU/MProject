function [Lig,cumDist]=shortpathligament(osteo,Orig,Insert,nrpoints)

%Initial guess of the ligament (straight line between the origin and
%insertion)
R = nrpoints; 
D = (0:1/(R-1):1)';
Vector = repmat(Insert-Orig,R,1);
Origin = repmat(Orig,R,1);
Lig = Origin + horzcat(D.*Vector(:,1),D.*Vector(:,2),D.*Vector(:,3));

Lig_start = Lig;

%Define an elastic matrix to update the ligament wrapping
Elastmatrix(:,1) = vertcat(1,(1:(R-2))',R);
Elastmatrix(:,2) = (1:R)';
Elastmatrix(:,3) = vertcat(1,(3:R)',R);

Distoud = zeros(R-1,1);
D3=1;

normals = osteo.normals;
vertices = osteo.vertices;

%Repeat until the update in distance is less than 0.001
while D3 >0.001 
    
    %Compute the mean of three subsequent points
    XYZtempnieuw = (Lig(Elastmatrix(:,1),:)+Lig(Elastmatrix(:,2),:)+Lig(Elastmatrix(:,3),:))/3;

    %Compute the closest points on the structure
    [IDX,d] = knnsearch(vertices,XYZtempnieuw); 
    
    %Compute the vector from the new points of the ligaments to the nearest
    %points on the structure
    vectors = XYZtempnieuw-vertices(IDX,:);
    unitvector = horzcat(vectors(:,1)./d,vectors(:,2)./d,vectors(:,3)./d) ;

    %Compute whether a point on the ligament lies within or without the
    %structure
    control = sign((unitvector(:,1)-normals(IDX,1)).^2+ (unitvector(:,2)-normals(IDX,2)).^2+(unitvector(:,3)-normals(IDX,3)).^2-2);
    distancestoplanes = abs(sum(normals(IDX,:).*vectors,2));
   
    signs = control.*distancestoplanes;
    
    %Reposition a point of the ligament by moving it to the surface of the
    %structure
    projections = XYZtempnieuw+horzcat(normals(IDX,1).*distancestoplanes,normals(IDX,2).*distancestoplanes,normals(IDX,3).*distancestoplanes); 
    Lig = [(XYZtempnieuw(:,1).*abs((control-1)/2)+projections(:,1).*((control+1)/2)) (XYZtempnieuw(:,2).*abs((control-1)/2)+projections(:,2).*((control+1)/2)) (XYZtempnieuw(:,3).*abs((control-1)/2)+projections(:,3).*((control+1)/2))];
    
    %The origin and insertion should be kept at the initial location.
    Lig(1,:) = Lig_start(1,:);
    Lig(R,:) = Lig_start(R,:);
    
    %Compute the length of the ligament
    dist=Lig(1:(R-1),:)-Lig(2:R,:);
    Distnieuw=(sqrt(sum(dist.^2,2)));
    cumDist=sum(Distnieuw);
     
    %Check the update in length of the ligament 
    D3=sum(sqrt(mean(Distnieuw-Distoud).^2));
    Distoud=Distnieuw;
       
   
end
