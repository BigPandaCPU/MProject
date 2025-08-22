function [ACL,PCL,FACL,FPCL] = CruciatePrediction(Femur,TibFib,Ff,Ft,Cruciates,nrpoints,radiusacl,radiuspcl,PolyCoef_cruciates,CreateOutput,outputfolder)

% Create single wrapping surface
[V,F] = mergesurfaces(TibFib,Ft,Femur,Ff);

PolyCoef_ACL = PolyCoef_cruciates.ACL_coef;
% ACL
% Update the indices
IndACL_Fem_merged = Cruciates.IndAKB_Fem + size(TibFib,1);
IndACL_Tib_merged = Cruciates.IndAKB_Tib;
%Compute the ACL
[FACL,ACL] = Cruciate_Builder(F,V,TibFib,Femur,IndACL_Fem_merged,IndACL_Tib_merged,nrpoints,radiusacl,PolyCoef_ACL);

% write stl
if CreateOutput==1
    FilenameACL= [outputfolder '/ACL.stl'];
    TRACL = triangulation(FACL,ACL);
    stlwrite (TRACL,FilenameACL);
    
   
end

% PCL
% define wrapping object Femur - tibia - ACL
[V,F] = Merge(V,F,ACL,FACL);
% Update the indices
IndPCL_Fem_merged = Cruciates.IndPKB_Fem + size(TibFib,1);
IndPCL_Tib_merged = Cruciates.IndPKB_Tib;
%Polynomial coefficients
PolyCoef_PCL = PolyCoef_cruciates.PCL_coef;
%Compute the PCL
[FPCL,PCL] = Cruciate_Builder(F,V,TibFib,Femur,IndPCL_Fem_merged,IndPCL_Tib_merged,nrpoints,radiuspcl,PolyCoef_PCL);

% write stl
if CreateOutput==1
    FilenamePCL= [outputfolder '/PCL.stl'];
    TRPCL = triangulation(FPCL,PCL);
    stlwrite (TRPCL,FilenamePCL);
  
    
end

end 
