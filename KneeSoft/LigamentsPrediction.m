function [MPFL,sMCLp,sMCLa,POL,ALL,LCL,LPFL,OPL,PP,V_full,FMPFL,FsMCLp,FsMCLa,FPOL,FALL,FLCL,FLPFL,FOPL,FPP,F_full] = ...
    LigamentsPrediction(Femur,TibFib,Patella,LatMen,MedMen,Ff,Fp,Ft,FLatMen,FMedMen,Lig,LigPat,nrpoints,nr_patpoints,...
    interpolationr,interpolationc,MedCartTib,LatCartTib,MenOut,DistFem,Thickness,CreateOutput,outputfolder)

% Merge tibia - femur - patella - meniscus
V = [TibFib;Femur;Patella;MedMen;LatMen];
F = [Ft;max(max(Ft))+Ff];
F = [F;max(max(F))+1+Fp];%(one vertex is not referenced)
F = [F;max(max(F))+FMedMen];
F = [F;max(max(F))+FLatMen];

% The indices that refer to the cartilage layer (on tibia and on femur) and
% the inner part of the meniscus should not be taken into account to 
% compute the wrapping of the ligaments

%Cartilage on tibia
IndTib = (1:size(TibFib,1))';
IndTib([LatCartTib.IndicesLatCart;MedCartTib.IndicesMedCart]) = [];
%Cartilage on femur
IndicesFem = (1:size(Femur,1))';
IndicesFem(DistFem.IndicesDistFem,:)=[];
IndFem = IndicesFem + size(TibFib,1);
%Keep all vertices on the patella
IndPat = (size(TibFib,1)+size(Femur,1):...
    size(TibFib,1)+size(Femur,1)+size(Patella,1))';
%Keep the outer vertices of the medial meniscus
IndMMOut = MenOut.IndicesMedMenOut + size(TibFib,1)+size(Femur,1)+size(Patella,1);
%Keep the outer vertices of the lateral meniscus
IndLMOut = MenOut.IndicesMedMenOut + size(TibFib,1)+size(Femur,1)+size(Patella,1)+size(MedMen,1);
%Combine the vertices
IndDef = [IndTib;IndFem;IndPat;IndMMOut;IndLMOut];
%Select the vertices
osteo.vertices = V(IndDef,:);
%Compute the normals
TR = triangulation(F,V); 
osteo.normals = vertexNormal(TR,IndDef);


% 1. MPFL
% 1.0 adjust indices
IndicesMPFLPat = Lig.IndicesMPFLPat + length(TibFib) + length(Femur);
IndicesMPFLFem = Lig.IndicesMPFLFem + length(TibFib);
% 1.1 Ligament builder
[MPFL,FMPFL,lenMPFL] = LigamentBuilder(V,F,osteo,IndicesMPFLPat,IndicesMPFLFem,nrpoints,interpolationr,interpolationc);
% 1.2 Add thickness
[FMPFL,MPFL] = addthickness2(MPFL,FMPFL,Thickness.MPFL);
% 1.3 No penetration
[MPFL,FMPFL] = nopenetration(MPFL,FMPFL,V,F);
% 1.4 Write STL
if CreateOutput==1
    if ~exist(outputfolder, 'dir')
        mkdir(outputfolder)
    end
    FilenameMPFL = [outputfolder '/MPFL.stl'];
    TRMPFL= triangulation(FMPFL,MPFL);
    stlwrite (TRMPFL,FilenameMPFL);
    FilenameMPFL = [outputfolder '/MPFL'];
   
end



% 2. sMCL - posteriar strand
% 2.0 adjust indices
IndicesMCLFem = Lig.IndicesMCLFem + length(TibFib);
% 2.1 Ligament development
[sMCLp,FsMCLp,lensMCL] = LigamentBuilder(V,F,osteo,IndicesMCLFem,Lig.IndicesMCLTib,nrpoints,interpolationr,interpolationc);
% 2.2 Add thickness
[FsMCLp,sMCLp] = addthickness1(sMCLp,FsMCLp,Thickness.sMCLp);
% 2.3 Flip normals
FsMCLp(:,4)=FsMCLp(:,2);
FsMCLp(:,2)=[];
% 2.4 Write STL
if CreateOutput==1
    FilenameMPFL = [outputfolder '/sMCLp.stl'];
    TRsMCL = triangulation(FsMCLp,sMCLp);
    stlwrite (TRsMCL,FilenameMPFL);
    
end


% 3. sMCL - anterior strand
% 3.0 adjust indices
IndicesdMCLFem = Lig.IndicesdMCLFem + length(TibFib);
% 3.1 Ligament development
[sMCLa,FsMCLa,lensMCLa] = LigamentBuilder(V,F,osteo,IndicesdMCLFem,Lig.IndicesdMCLTib,nrpoints,interpolationr,interpolationc);
% 3.2 Add thickness
[FsMCLa,sMCLa] = addthickness1(sMCLa,FsMCLa,Thickness.sMCLa);
% 3.3 Flip normals
FsMCLa(:,4)=FsMCLa(:,2);
FsMCLa(:,2)=[];
% 3.4 Write STL
if CreateOutput==1
    FilenamesMCLa = [outputfolder '/sMCLa.stl'];
    TRsMCL = triangulation(FsMCLa,sMCLa);
    stlwrite (TRsMCL,FilenamesMCLa);
     
end


% 4. POL
% 4.0 adjust indices
IndicesPOLFem = Lig.IndicesPOLFem + length(TibFib);
% 4.1 Ligament development
[POL,FPOL,lenPOL] = LigamentBuilder(V,F,osteo,IndicesPOLFem,Lig.IndicesPOLTib,nrpoints,interpolationr,interpolationc);
% 4.2 Add thickness
[FPOL,POL] = addthickness1(POL,FPOL,Thickness.POL);
% 4.3 Flip normals
FPOL(:,4)=FPOL(:,2);
FPOL(:,2)=[];
% 4.4 Write STL
if CreateOutput==1
    FilenamesPOL = [outputfolder '/POL.stl'];
    TRsPOL = triangulation(FPOL,POL);
    stlwrite (TRsPOL,FilenamesPOL);
   
  
end


%5. Anterolateral ligament (ALL)
%5.0 adjust indices
IndicesALLFem = Lig.IndicesALLFem + length(TibFib);
%5.1 Ligament development
[ALL,FALL,lenALL] = LigamentBuilder(V,F,osteo,IndicesALLFem,Lig.IndicesALLTib,nrpoints,interpolationr,interpolationc);
%5.2 Add thickness
[FALL,ALL] = addthickness1(ALL,FALL,Thickness.ALL);
%5.3  Flip normals
FALL(:,4)=FALL(:,2);
FALL(:,2)=[];
%5.5 Write STL
if CreateOutput==1
    FilenameALL= [outputfolder '/ALL.stl'];
    TRALL = triangulation (FALL,ALL);
    stlwrite (TRALL,FilenameALL);
   
end

% 6. LCL
% 6.0 adjust indices
IndicesLCLFem = Lig.IndicesLCLFem + length(TibFib);
% 6.1 Ligament development
[LCL,FLCL,lenLCL] = LigamentBuilder(V,F,osteo,IndicesLCLFem,Lig.IndicesLCLTib,nrpoints,interpolationr,interpolationc);
% 6.2 Add thickness
[FLCL,LCL] = addthickness2(LCL,FLCL,Thickness.LCL);
% 6.3 Flip normals
FLCL(:,4)=FLCL(:,2);
FLCL(:,2)=[];
% 6.4 no penetration
[LCL,FLCL] = nopenetration(LCL,FLCL,V,F);
% 6.5 Write STL
if CreateOutput==1
    FilenameLCL= [outputfolder '/LCL.stl'];
    TRLCL = triangulation (FLCL,LCL);
    stlwrite (TRLCL,FilenameLCL);
   
end


% 7. LPFL
% 7.0 adjust indices
IndicesLPFLFem = Lig.IndicesLPFLFem + length(TibFib);
IndicesLPFLPat = Lig.IndicesLPFLPat + length(TibFib) + length(Femur);
% 7.1 Ligament development
[LPFL,FLPFL,lenLPFL] = LigamentBuilder(V,F,osteo,IndicesLPFLFem,IndicesLPFLPat,nrpoints,interpolationr,interpolationc);
% 7.2 Add thickness
[FLPFL,LPFL] = addthickness2(LPFL,FLPFL,Thickness.LPFL);
% 7.4 no penetration
[LPFL,FLPFL] = nopenetration(LPFL,FLPFL,V,F);
% 7.4 Write STL
if CreateOutput==1
    FilenameLPFL= [outputfolder '/LPFL.stl'];
    TRLPFL = triangulation (FLPFL,LPFL);
    stlwrite (TRLPFL,FilenameLPFL);
    
end


% 8. OPL
% 8.0 adjust indices
IndicesOPLFem = Lig.IndicesOPLFem + length(TibFib);
% 8.1 Ligament development
[OPL,FOPL,lenOPL] = LigamentBuilder(V,F,osteo,IndicesOPLFem,Lig.IndicesOPLTib,nrpoints,interpolationr,interpolationc);
% 8.2 Add thickness
[FOPL,OPL] = addthickness2(OPL,FOPL,Thickness.OPL);
% 8.3 Flip normals
FOPL(:,4)=FOPL(:,2);
FOPL(:,2)=[];
% 8.4 no penetration
[OPL,FOPL] = nopenetration(OPL,FOPL,V,F);
% 8.5 Write STL
if CreateOutput==1
    FilenameOPL= [outputfolder '/OPL.stl'];
    TROPL = triangulation (FOPL,OPL);
    stlwrite (TROPL,FilenameOPL);
   
end


% 9. PatellarTendon
% 9.0 adjust indices
IndicesPatProx = LigPat.IndicesPatProx + length(TibFib) + length(Femur);
% 9.1 Tendon development
[FPP, PP] = PatellarTendonBuilder(V,F,osteo,IndicesPatProx,LigPat.IndicesPatDist,nr_patpoints,nrpoints,interpolationr,interpolationc);
% Omdraaien van de normals en stlwrite zit vervat in PTNew function
% write STL
if CreateOutput==1
    FilenamePP= [outputfolder '/PP.stl'];
    TRPP = triangulation(FPP,PP);
    stlwrite (TRPP,FilenamePP);
    
end


% 10. merge all ligaments with tibia, femur and patella
[V,F]=Merge(V,F,MPFL,FMPFL);
[V,F]=Merge(V,F,sMCLp,FsMCLp);
[V,F]=Merge(V,F,sMCLa,FsMCLa);
[V,F]=Merge(V,F,POL,FPOL);
[V,F]=Merge(V,F,OPL,FOPL);
[V,F]=Merge(V,F,ALL,FALL);
[V,F]=Merge(V,F,LCL,FLCL);
[V,F]=Merge(V,F,LPFL,FLPFL);
[V_full,F_full]=Merge(V,F,PP,FPP);
if CreateOutput==1
    FilenameLig= [outputfolder '/OsCartMenLig.stl'];
    TRLig = triangulation(F_full,V_full);
    stlwrite (TRLig,FilenameLig);
   
end

end
