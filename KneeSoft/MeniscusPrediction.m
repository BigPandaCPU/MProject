function [FLatMen,VLatMen,FMedMen,VMedMen] = MeniscusPrediction(Femur,TibFib,Ff,Ft,Meniscus,ThicknessMenL,ThicknessMenM,DiaMenL,DiaMenM,nrpoints,PolyCoef,CreateOutput,outputfolder)

%Create single wrapping surface
[V,F] = mergesurfaces(TibFib,Ft,Femur,Ff);

%Define the search area (limit the search area to a distance of 15mm)
[idx(:,1),dist] = knnsearch([TibFib(Meniscus.IndTibLatMen,:);TibFib(Meniscus.IndTibMedMen,:)],V);
idx(:,2) = 1:length(V);
idx = idx(dist<15,:);
IDX = unique(idx(:,2));
[V, F, ~] = RepatchFromIndices(V,F,IDX);
[Fstructure,Vstructure] = reducepatch(F,V,0.7);

%Define a tube from the anterior to posterior horn
%Lateral Meniscus
ThicknessLatCoef = PolyCoef.LatMen_Thickness_coeff;
WidthLatCoef = PolyCoef.LatMen_Length_coeff;
LateralMenInd = Meniscus.IndTibLatMen;
[FLatMen,VLatMen] = DefineMeniscus(Fstructure,Vstructure,TibFib,Femur,Ft,Ff,LateralMenInd,ThicknessMenL,DiaMenL,ThicknessLatCoef,WidthLatCoef,nrpoints);

%Medial Meniscus
ThicknessMedCoef = PolyCoef.MedMen_Thickness_coeff;
WidthMedCoef = PolyCoef.LatMen_Length_coeff;
MedialMenInd = Meniscus.IndTibMedMen;
[FMedMen,VMedMen] = DefineMeniscus(Fstructure,Vstructure,TibFib,Femur,Ft,Ff,MedialMenInd,ThicknessMenM,DiaMenM,ThicknessMedCoef,WidthMedCoef,nrpoints);
CreateOutput=0;
if CreateOutput==1
    if ~exist(outputfolder, 'dir')
       mkdir(outputfolder)
    end
    % lateral meniscus
    FilenameLM= [outputfolder '/LateralMeniscus.stl'];
    TRLM = triangulation(FLatMen,VLatMen);
    stlwrite (TRLM,FilenameLM);
    
       % medial meniscus
    FilenameMM= [outputfolder '/MedialMeniscus.stl'];
    TRMM = triangulation(FMedMen,VMedMen);
    stlwrite (TRMM,FilenameMM);

end

end