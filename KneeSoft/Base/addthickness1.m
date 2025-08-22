function [Flig,Vlig] = addthickness1(Vlig,Flig,d) 

% Determine normals of the structure
TR = triangulation(Flig,Vlig);
normals = vertexNormal(TR);
inversednormals = normals.*-1;

Distance = ones(length(Vlig),1)*d;

% Detect edges
% No thickness on the edges
[indices_edges] = detectedges(Vlig,Flig);
Edges = (Vlig(indices_edges,:));

Distance(indices_edges)= 0;

% 2. Points close to the edge should be rounded (no steps in the ligament
% structure)
Idx = knnsearch(Vlig,Edges,'k',100);
Idx = Idx(:);
Idx = unique(Idx); %avoid duplicates
IdxVert = Vlig(Idx,:);

[Idx2,A] = knnsearch(Edges,IdxVert);
A = (sqrt(sqrt((A./max(A))))).*d;
Distance(Idx) = A(:,:);
Distance(indices_edges)=0;

for i=1:40
    Idx3 = knnsearch(Vlig,IdxVert,'K',40);
    Idx3 = Idx(:);
    Distance(Idx3)=mean(Distance(Idx3),2);
    Distances(indices_edges)=0;
end

% Add the thickness
%Inner part of the ligament
VligInner = Vlig + [inversednormals(:,1).*Distance inversednormals(:,2).*Distance inversednormals(:,3).*Distance];

% Fuse the inner and the outer part of the ligament
Vlig= [Vlig;VligInner];
Flig = [Flig;(Flig+length(VligInner))];

end 