function [FACL,VACL] = Cruciate_Builder(F,V,TibFib,Femur,Ind_Fem,Ind_Tib,nrpoints,radiustendon,PolyCoef)

% Initialize
OrigTib = V(Ind_Tib,:);
InsFem = V(Ind_Fem,:);

% Define vector from tibia to femur for all points
Vector = InsFem - OrigTib;
D = (0:1/(nrpoints-1):1)';

centerline = repmat(OrigTib,nrpoints,1) + [D.*repmat(Vector(1,1),nrpoints,1), D.*repmat(Vector(1,2),nrpoints,1),  D.*repmat(Vector(1,3),nrpoints,1) ];

% Reduce and refine search area (only use vertices near the articulating
% surface)
meancenter = (V(Ind_Fem,:)+V(Ind_Tib,:))/2; 
idx = rangesearch(V,meancenter,80); 
idx = cell2mat(idx)'; 

%Do not take points on the origin and insertion area into account
IDXA = rangesearch(V,V(Ind_Tib,:),radiustendon);
IDXA = cell2mat(IDXA); 
IDXA = transpose(IDXA);
IDX = setdiff(idx,IDXA,'rows');

IDXB = rangesearch(V,V(Ind_Fem,:),radiustendon); 
IDXB = cell2mat(IDXB); 
IDXB = transpose(IDXB);
IDX = setdiff(IDX,IDXB,'rows');

[V, F, ~] = RepatchFromIndices(V,F,IDX);
[Fstructure,Vstructure] = reducepatch(F,V,0.5);

%Scaling for cruciates
scaling_cruc = zeros(nrpoints,1);
for i=1:nrpoints
    scaling_cruc(i,:)= (PolyCoef(1,1)*(i^4) + PolyCoef(1,2)*(i^3) + PolyCoef(1,3)*(i^2) + PolyCoef(1,4)*(i) + PolyCoef(1,5))*radiustendon;
end

%Get the shortest path from origin to insertion
[CenterlineEstimate] = shortpathviapoints(Vstructure,Fstructure,scaling_cruc,centerline,nrpoints); % variërende straal r in shortpathviapoints

%Create a tube from the centerline
[x,y,z] = tubeplotradius(CenterlineEstimate(:,1),CenterlineEstimate(:,2),CenterlineEstimate(:,3),scaling_cruc,'r',10,[10 10 10]);

% Attach ends to bone
[t,p]=size(x);
for i=1:p
    temp=[x(1,i) y(1,i) z(1,i)];
    idx=knnsearch(TibFib,temp);
    x(1,i)=TibFib(idx,1);
    y(1,i)=TibFib(idx,2);
    z(1,i)=TibFib(idx,3);
    
    temp=[x(length(x),i) y(length(x),i) z(length(x),i)];
    idx=knnsearch(Femur,temp);
    x(length(x),i)=Femur(idx,1);
    y(length(x),i)=Femur(idx,2);
    z(length(x),i)=Femur(idx,3);
end

[FACL,VACL] = surf2patch(x,y,z,'triangles');


end


