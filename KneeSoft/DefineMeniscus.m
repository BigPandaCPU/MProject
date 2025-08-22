function [FMen,VMen] = DefineMeniscus(Fstructure,Vstructure,TibFib,Femur,Ft,Ff,IndMen,ThicknessMen,WidthMen,PolyCoefThick,PolyCoefWidth,nrpoints)

%1. Define a tube from the anterior to posterior horn

%Define a function that describes the varying thickness over the length
scaling_thick = zeros(nrpoints,1);
for i=1:nrpoints
    scaling_thick(i,:)= (PolyCoefThick(1,1)*(i^4) + PolyCoefThick(1,2)*(i^3) + PolyCoefThick(1,3)*(i^2) + PolyCoefThick(1,4)*i + PolyCoefThick(1,5));
end
Thickness_scaled = scaling_thick.* ThicknessMen;

%Identify tibia points en define semispline from origin to insertion
points = TibFib(IndMen,:);
wrappingpoints = spline3D(points,nrpoints);

%The spline point penetrate the tibia surface => update using
%shortpathviapoints which will update the wrapping points
%shortpath with offset
[centerline]=shortpathviapoints(Vstructure,Fstructure,Thickness_scaled,wrappingpoints,nrpoints); % variërende dikte meniscus; sinusfunctie

[centerLoc, circleNormal, radius] = CircFit3D(centerline);

%2. Define triangles

%Define a function that describes the varying width over the length
scaling_wid = zeros(nrpoints,1);
for j=1:nrpoints
    scaling_wid(j,:)= (PolyCoefWidth(1,1)*(j^4) + PolyCoefWidth(1,2)*(j^3) + PolyCoefWidth(1,3)*(j^2) + PolyCoefWidth(1,4)*j + PolyCoefWidth(1,5));
end
Width_scaled = scaling_wid.*WidthMen;

%Define the top of the triangles (near the femur surface)
Pointsup = centerline + Thickness_scaled.*repmat(circleNormal',nrpoints,1);
%Define the bottom of the triangles (near the tibia surface)
Pointsdown = centerline - Thickness_scaled.*repmat(circleNormal',nrpoints,1);

%Define the third vertex of the triangle (inwards)
Vectorcenter = centerline - repmat(centerLoc,nrpoints,1);
distance = sqrt(sum(Vectorcenter.^2,2));
Vectorcenter = Vectorcenter./distance;
Pointsin = centerline - Width_scaled.*Vectorcenter;

%Smoothen the inner rim of the meniscus
[idx,~] = knnsearch(TibFib,Pointsin);
Pointsin = TibFib(idx,:);
for i=1:2
    Pointsin = smoothplot(Pointsin);
end

% Connecting the vertices of the triangles
x=[Pointsin(:,1) (Pointsin(:,1)+0.2*(Pointsdown(:,1)-Pointsin(:,1))) (Pointsin(:,1)+0.4*(Pointsdown(:,1)-Pointsin(:,1))) (Pointsin(:,1)+0.6*(Pointsdown(:,1)-Pointsin(:,1))) (Pointsin(:,1)+0.8*(Pointsdown(:,1)-Pointsin(:,1))) Pointsdown(:,1) (Pointsdown(:,1)+0.2*(Pointsup(:,1)-Pointsdown(:,1))) (Pointsdown(:,1)+0.4*(Pointsup(:,1)-Pointsdown(:,1))) (Pointsdown(:,1)+0.6*(Pointsup(:,1)-Pointsdown(:,1))) (Pointsdown(:,1)+0.8*(Pointsup(:,1)-Pointsdown(:,1))) Pointsup(:,1) (Pointsup(:,1)+0.2*(Pointsin(:,1)-Pointsup(:,1))) (Pointsup(:,1)+0.4*(Pointsin(:,1)-Pointsup(:,1))) (Pointsup(:,1)+0.6*(Pointsin(:,1)-Pointsup(:,1))) (Pointsup(:,1)+0.8*(Pointsin(:,1)-Pointsup(:,1))) Pointsin(:,1)];
y=[Pointsin(:,2) (Pointsin(:,2)+0.2*(Pointsdown(:,2)-Pointsin(:,2))) (Pointsin(:,2)+0.4*(Pointsdown(:,2)-Pointsin(:,2))) (Pointsin(:,2)+0.6*(Pointsdown(:,2)-Pointsin(:,2))) (Pointsin(:,2)+0.8*(Pointsdown(:,2)-Pointsin(:,2))) Pointsdown(:,2) (Pointsdown(:,2)+0.2*(Pointsup(:,2)-Pointsdown(:,2))) (Pointsdown(:,2)+0.4*(Pointsup(:,2)-Pointsdown(:,2))) (Pointsdown(:,2)+0.6*(Pointsup(:,2)-Pointsdown(:,2))) (Pointsdown(:,2)+0.8*(Pointsup(:,2)-Pointsdown(:,2))) Pointsup(:,2) (Pointsup(:,2)+0.2*(Pointsin(:,2)-Pointsup(:,2))) (Pointsup(:,2)+0.4*(Pointsin(:,2)-Pointsup(:,2))) (Pointsup(:,2)+0.6*(Pointsin(:,2)-Pointsup(:,2))) (Pointsup(:,2)+0.8*(Pointsin(:,2)-Pointsup(:,2))) Pointsin(:,2)];
z=[Pointsin(:,3) (Pointsin(:,3)+0.2*(Pointsdown(:,3)-Pointsin(:,3))) (Pointsin(:,3)+0.4*(Pointsdown(:,3)-Pointsin(:,3))) (Pointsin(:,3)+0.6*(Pointsdown(:,3)-Pointsin(:,3))) (Pointsin(:,3)+0.8*(Pointsdown(:,3)-Pointsin(:,3))) Pointsdown(:,3) (Pointsdown(:,3)+0.2*(Pointsup(:,3)-Pointsdown(:,3))) (Pointsdown(:,3)+0.4*(Pointsup(:,3)-Pointsdown(:,3))) (Pointsdown(:,3)+0.6*(Pointsup(:,3)-Pointsdown(:,3))) (Pointsdown(:,3)+0.8*(Pointsup(:,3)-Pointsdown(:,3))) Pointsup(:,3) (Pointsup(:,3)+0.2*(Pointsin(:,3)-Pointsup(:,3))) (Pointsup(:,3)+0.4*(Pointsin(:,3)-Pointsup(:,3))) (Pointsup(:,3)+0.6*(Pointsin(:,3)-Pointsup(:,3))) (Pointsup(:,3)+0.8*(Pointsin(:,3)-Pointsup(:,3))) Pointsin(:,3)];
[FMenTriangle,VMenTriangle] = surf2patch(x,y,z,'triangles');

%3. Correct for local penetration

% Project points that penetrate femur
[VMen,FMen] = nopenetration(VMenTriangle,FMenTriangle,Femur,Ff);
% Project points that penetrate tibia
[VMen,FMen] = nopenetration(VMen,FMen,TibFib,Ft);

%Smoothen the meniscus
[VMen] = taubinsmooth(FMen,VMen);

end