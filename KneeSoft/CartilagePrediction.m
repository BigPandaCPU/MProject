function [FemWithCart,PatWithCart,TibWithCart] = CartilagePrediction(Femur,Patella,Tibia,MeanFemur,Ff,Fp,Ft,MedCartTib,LatCartTib,FemCart,PatCart,CreateOutput,outputfolder)

% Cartilage Prediction 

% SCALE FACTOR
[d,Z,transform] = procrustes(Femur,MeanFemur,'scaling',1);
scalefactor = transform.b;

% MEDIAL TIBIAPLATEAU
% normals medial tibia plateau
TR = triangulation(Ft,Tibia);
normals = vertexNormal(TR,MedCartTib.IndicesMedCart); 
% introduce scalingsfactor
MedCartTibScaled = MedCartTib.MedCartTibMean.*scalefactor;
% projection medial tibia plateau
tmp = Tibia(MedCartTib.IndicesMedCart,:);
updpoints = Tibia(MedCartTib.IndicesMedCart,:)+repmat(MedCartTibScaled,1,3).*normals;
figure 
plot3(tmp(:,1), tmp(:, 2), tmp(:,3),'b.')
%trimesh(dt.)
hold on
plot3(updpoints(:,1),updpoints(:,2),updpoints(:,3), 'g.')
axis('equal')

figure
tri = delaunay(tmp(:,2),tmp(:,3));
trisurf(tri,tmp(:,2),tmp(:,3),tmp(:,1)), 
hold on
tri2 = delaunay(updpoints(:,2),updpoints(:,3));
trisurf(tri2,updpoints(:,2),updpoints(:,3),updpoints(:,1)) 



TibWithCart = Tibia;

TibWithCart(MedCartTib.IndicesMedCart,:) = updpoints; 
% Put the thickness of the cartilage layer near the edges to zero
Fmedcartselected = SelectFaces(Ft,MedCartTib.IndicesMedCart);
[Indices_edges] = detectedges(TibWithCart,Fmedcartselected);
[Indices_edges] = unique(Indices_edges);
% Vtn = TibWithCart;
TibWithCart(Indices_edges,:) = Tibia(Indices_edges,:); 


% LATERAAL TIBIAPLATEAU
% normals lateraal tibiplateau
normals = vertexNormal(TR,LatCartTib.IndicesLatCart);
% introduce scalingsfactor
LatCartTibScaled = LatCartTib.LatCartTibMean.*scalefactor;
% projection lateraal
updpointsLT = Tibia(LatCartTib.IndicesLatCart,:) + repmat(LatCartTibScaled,1,3).*normals;
TibWithCart(LatCartTib.IndicesLatCart,:) = updpointsLT; 
% Put the thickness of the cartilage layer near the edges to zero
Flatcartselected = SelectFaces(Ft,LatCartTib.IndicesLatCart);
[Indices_edges] = detectedges(TibWithCart,Flatcartselected);
[Indices_edges] = unique(Indices_edges);
TibWithCart(Indices_edges,:) = Tibia(Indices_edges,:);
TRTibWithCart = triangulation(Ft,TibWithCart);

% FEMUR
% normals femur
TR = triangulation(Ff,Femur);
normals = vertexNormal(TR,FemCart.IndicesFemCart);
% introduce scalingsfactor
FemCartScaled = FemCart.FemCartMean.*scalefactor;
% projection femur
updpoints = Femur(FemCart.IndicesFemCart,:)+repmat(FemCartScaled,1,3).*normals;
FemWithCart = Femur;
FemWithCart(FemCart.IndicesFemCart,:) = updpoints; 
% Put the thickness of the cartilage layer near the edges to zero
FFemcartselected = SelectFaces(Ff,FemCart.IndicesFemCart);
[Indices_edges] = detectedges(FemWithCart,FFemcartselected);
[Indices_edges] = unique(Indices_edges);
FemWithCart(Indices_edges,:) = Femur(Indices_edges,:);
TRFemWithCart = triangulation(Ff,FemWithCart);  
    
% PATELLA
% normals femur
TR = triangulation(Fp,Patella);
normals = vertexNormal(TR,PatCart.IndicesPatCart);
% introduce scalingsfactor
PatCartScaled = PatCart.PatCartMean.*scalefactor;
% projection patella
updpoints = Patella(PatCart.IndicesPatCart,:)+repmat(PatCartScaled,1,3).*normals;
PatWithCart = Patella;
PatWithCart(PatCart.IndicesPatCart,:) = updpoints;
% Put the thickness of the cartilage layer near the edges to zero
FPatcartselected = SelectFaces(Fp,PatCart.IndicesPatCart);
[Indices_edges] = detectedges(PatWithCart,FPatcartselected);
[Indices_edges] = unique(Indices_edges);
PatWithCart(Indices_edges,:) = Patella(Indices_edges,:);
TRPatWithCart = triangulation(Fp,PatWithCart);


if CreateOutput==1
       
    % CREATE STLs & OBJs
    FilenameTib = [outputfolder '/TibiaCartilage2.stl'];
    FilenameFem = [outputfolder '/FemurCartilage2.stl'];
    FilenamePat = [outputfolder '/PatellaCartilage2.stl'];
    TRTibWithCart_new.vertices = TRTibWithCart.Points;
    TRTibWithCart_new.faces = TRTibWithCart.ConnectivityList;
    stlWrite(FilenameTib, TRTibWithCart_new);
%     stlwrite(FilenameFem, TRFemWithCart.ConnectivityList, TRFemWithCart.Points);
%     stlwrite(FilenamePat, TRPatWithCart.ConnectivityList, TRPatWithCart.Points);

   
end
end
