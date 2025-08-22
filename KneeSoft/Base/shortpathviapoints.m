function [XYZtemp] = shortpathviapoints(Vstructure,Fstructure,r,centerline,nrpoints)

%Initial guess of the ligament (straight line between the origin and
%insertion)
XYZtemp1 = centerline;
XYZtemp = centerline;

%Define an elastic matrix to update the ligament wrapping
Elastmatrix(:,1)=vertcat(1,(1:(nrpoints-2))',nrpoints);
Elastmatrix(:,2)=(1:nrpoints)';
Elastmatrix(:,3)=vertcat(1,(3:nrpoints)',nrpoints);

TR = triangulation(Fstructure,Vstructure);
normals = -vertexNormal(TR);

D2=0;
D3=0.1;
iterations=1;

tic
while D3 >0.00001
    iterations = iterations+1;
    if iterations > 200
        break
    end
    %Compute the mean of three subsequent points
    XYZtempnieuw = (XYZtemp(Elastmatrix(:,1),:)+XYZtemp(Elastmatrix(:,2),:)+XYZtemp(Elastmatrix(:,3),:))/3;
    %Compute the closest points on the structure
    [IDX,d] = knnsearch(Vstructure,XYZtempnieuw);
    
    %Compute the vector from the new points of the ligaments to the nearest
    %points on the structure
    vectors = XYZtempnieuw - Vstructure(IDX,:);
    unitvector=horzcat(vectors(:,1)./d,vectors(:,2)./d,vectors(:,3)./d) ;

    %Compute whether a point on the ligament lies within or without the
    %structure
    control=sign((unitvector(:,1)-normals(IDX,1)).^2+ (unitvector(:,2)-normals(IDX,2)).^2+(unitvector(:,3)-normals(IDX,3)).^2-2);
    distancestoplanes=abs(sum(normals(IDX,:).*vectors,2));
    
    %Reposition a point of the ligament by moving it to the surface of the
    %structure
    signs=control.*distancestoplanes;
    displacement = r-signs;
    displacement = ((sign(displacement)+1)/2).*displacement;
    XYZtemp = XYZtempnieuw - horzcat(normals(IDX,1).*displacement,normals(IDX,2).*displacement,normals(IDX,3).*displacement);


    XYZtemp(1,:)=XYZtemp1(1,:);
    XYZtemp(nrpoints,:)=XYZtemp1(nrpoints,:);
    dist=XYZtemp-vertcat(XYZtemp(2:nrpoints,:),XYZtemp1(nrpoints,:));
    D=max(cumsum(sqrt(sum(dist.^2,2))));
    D3=abs(D-D2);
    D2=D;

end
toc
end