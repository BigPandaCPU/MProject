clear all;
close all;
warning('off','MATLAB:triangulation:PtsNotInTriWarnId')
%% Input parameters
addpath('./InputData')
addpath('./Base');

%Load random structures
load('ExampleData\RandomStructures.mat');
figure
plot3(Femur(:,1), Femur(:,2),Femur(:,3),'r.')
hold on
plot3(TibFib(:,1), TibFib(:,2),TibFib(:,3),'g.')
plot3(Patella(:,1), Patella(:,2),Patella(:,3),'b.')
axis('equal')


%Load mean structures
load('InputData\MeanStructures.mat');


figure
plot3(MeanTibFib(:,1), MeanTibFib(:,2), MeanTibFib(:, 3),'r.')
axis('equal')
hold on
plot3(MeanPat(:,1), MeanPat(:,2), MeanPat(:, 3),'g.')
plot3(MeanFemur(:,1), MeanFemur(:,2), MeanFemur(:, 3),'b.')

%Load mean cartilage distance maps and indices
MedCartTib = load('MedCartTibMean.mat');
LatCartTib = load('LatCartTibMean.mat');
FemCart = load('FemCartMean.mat');
PatCart = load('PatCartMean');

%Load Meniscus
Meniscus = load('IndicesMeniscus.mat');
PolyCoef = load('PolynomialCoef.mat');

%Load ligament parameters  韧带参数
Lig = load('Ligaments.mat');
LigPat = load('LigamentsPatella.mat');  %%髌骨韧带
MenOut = load('IndicesMedMenOut.mat');  %%
DistFem = load('IndicesDistFem.mat');

%Load cruciate parameters 十字
Cruciates = load('IndicesCruciates.mat');
PolyCoef_cruciates = load('PolynomialCoefCruciates.mat');

%Create output
CreateOutput = 0;
currentFolder = pwd;
outputfolder = [currentFolder '\OutputData'];
mkdir('./OutputData')
%% Add cartilage to the bones

[FemWithCart,PatWithCart,TibWithCart] = CartilagePrediction(Femur,Patella,TibFib,MeanFemur,...
    Ff,Fp,Ft,MedCartTib,LatCartTib,FemCart,PatCart,CreateOutput,outputfolder);

figure
plot3(FemWithCart(:,1), FemWithCart(:,2),FemWithCart(:,3),'r.')
hold on
plot3(TibWithCart(:,1), TibWithCart(:,2),TibWithCart(:,3),'g.')
plot3(PatWithCart(:,1), PatWithCart(:,2),PatWithCart(:,3),'b.')
axis('equal')

list_femcart = ismember(Ff,FemCart.IndicesFemCart);
FemPlot = repmat([0.95 0.95 0.87],size(Ff,1),1);
FemPlot(sum(list_femcart,2)==3,:) = repmat([0.98 0.98 0.96],sum((sum(list_femcart,2)==3)),1);

list_patcart = ismember(Fp,PatCart.IndicesPatCart);
PatPlot = repmat([0.95 0.95 0.87],size(Fp,1),1);
PatPlot(sum(list_patcart,2)==3,:) = repmat([0.98 0.98 0.96],sum((sum(list_patcart,2)==3)),1);

list_tibcart = ismember(Ft,[MedCartTib.IndicesMedCart;LatCartTib.IndicesLatCart]);
TibPlot = repmat([0.95 0.95 0.87],size(Ft,1),1);
TibPlot(sum(list_tibcart,2)==3,:) = repmat([0.98 0.98 0.96],sum((sum(list_tibcart,2)==3)),1);

figure
trisurf(Ff,FemWithCart(:,1),FemWithCart(:,2),FemWithCart(:,3),'facevertexcdata',FemPlot,'EdgeColor','none')
hold on
% trisurf(Fp,PatWithCart(:,1),PatWithCart(:,2),PatWithCart(:,3),'facevertexcdata',PatPlot,'EdgeColor','none')
% trisurf(Ft,TibWithCart(:,1),TibWithCart(:,2),TibWithCart(:,3),'facevertexcdata',TibPlot,'EdgeColor','none')
axis equal;
light;
material dull;

%% Add meniscus
ThicknessMenL = 4;
ThicknessMenM = 4.5;
DiaMenL = 12;
DiaMenM = 16;
nrpoints = 75;
[FLatMen,LatMen,FMedMen,MedMen] = MeniscusPrediction(FemWithCart,TibWithCart,Ff,Ft,Meniscus,ThicknessMenL,ThicknessMenM,DiaMenL,DiaMenM,nrpoints,PolyCoef,CreateOutput,outputfolder);

MenPlot = [0.95 0.9 0.9];
figure
trisurf(Ff,FemWithCart(:,1),FemWithCart(:,2),FemWithCart(:,3),'facevertexcdata',FemPlot,'EdgeColor','none')
hold on
trisurf(Fp,PatWithCart(:,1),PatWithCart(:,2),PatWithCart(:,3),'facevertexcdata',PatPlot,'EdgeColor','none')
trisurf(Ft,TibWithCart(:,1),TibWithCart(:,2),TibWithCart(:,3),'facevertexcdata',TibPlot,'EdgeColor','none')
trisurf(FLatMen,LatMen(:,1),LatMen(:,2),LatMen(:,3),'facevertexcdata',MenPlot,'EdgeColor','none')
trisurf(FMedMen,MedMen(:,1),MedMen(:,2),MedMen(:,3),'facevertexcdata',MenPlot,'EdgeColor','none')
axis equal;light;material dull;

%% Add ligaments
%Interpolation points for the ligaments
nrpoints = 44;
%Interpolation points for the patellar tendon
nr_patpoints = 25;
%interpolation points to create the surface of the ligaments and tendon
interpolationr = 94;
interpolationc = 183;

%Thickness of the ligaments
Thickness.MPFL = 1.67;
Thickness.sMCLp = 2.1;
Thickness.sMCLa = 2.1;
Thickness.POL = 1;
Thickness.ALL = 1.5;
Thickness.LCL = 2.2;
Thickness.LPFL = 1.8;
Thickness.OPL = 1.4;


[MPFL,sMCLp,sMCLa,POL,ALL,LCL,LPFL,OPL,PP,V_full,FMPFL,FsMCLp,FsMCLa,FPOL,FALL,FLCL,FLPFL,FOPL,FPP,F_full] = ...
    LigamentsPrediction(Femur,TibFib,Patella,LatMen,MedMen,Ff,Fp,Ft,FLatMen,FMedMen,...
    Lig,LigPat,nrpoints,nr_patpoints,interpolationr,interpolationc,MedCartTib,LatCartTib,MenOut,DistFem,Thickness,CreateOutput,outputfolder);


figure
trisurf(Ff,FemWithCart(:,1),FemWithCart(:,2),FemWithCart(:,3),'facevertexcdata',FemPlot,'EdgeColor','none')
hold on
trisurf(Fp,PatWithCart(:,1),PatWithCart(:,2),PatWithCart(:,3),'facevertexcdata',PatPlot,'EdgeColor','none')
trisurf(Ft,TibWithCart(:,1),TibWithCart(:,2),TibWithCart(:,3),'facevertexcdata',TibPlot,'EdgeColor','none')
trisurf(FLatMen,LatMen(:,1),LatMen(:,2),LatMen(:,3),'facevertexcdata',MenPlot,'EdgeColor','none')
trisurf(FMedMen,MedMen(:,1),MedMen(:,2),MedMen(:,3),'facevertexcdata',MenPlot,'EdgeColor','none')
trisurf(FMPFL,MPFL(:,1),MPFL(:,2),MPFL(:,3),'FaceColor','c','EdgeColor','none')
trisurf(FsMCLp,sMCLp(:,1),sMCLp(:,2),sMCLp(:,3),'FaceColor','c','EdgeColor','none')
trisurf(FsMCLa,sMCLa(:,1),sMCLa(:,2),sMCLa(:,3),'FaceColor','c','EdgeColor','none')
trisurf(FPOL,POL(:,1),POL(:,2),POL(:,3),'FaceColor','c','EdgeColor','none')
trisurf(FALL,ALL(:,1),ALL(:,2),ALL(:,3),'FaceColor','c','EdgeColor','none')
trisurf(FLCL,LCL(:,1),LCL(:,2),LCL(:,3),'FaceColor','c','EdgeColor','none')
trisurf(FLPFL,LPFL(:,1),LPFL(:,2),LPFL(:,3),'FaceColor','c','EdgeColor','none')
trisurf(FOPL,OPL(:,1),OPL(:,2),OPL(:,3),'FaceColor','c','EdgeColor','none')
trisurf(FPP,PP(:,1),PP(:,2),PP(:,3),'FaceColor','c','EdgeColor','none')
axis equal;light;material dull;

%% Add the cruciates
%Number of points along the longitudinal axis
nrpoints = 15;
%Radius ACL
radiusacl = 3.5;
%Radius PCL
radiuspcl = 3;
[ACL,PCL,FACL,FPCL] = CruciatePrediction(Femur,TibFib,Ff,Ft,Cruciates,nrpoints,radiusacl,radiuspcl,PolyCoef_cruciates,CreateOutput,outputfolder);

figure
trisurf(Ff,FemWithCart(:,1),FemWithCart(:,2),FemWithCart(:,3),'facevertexcdata',FemPlot,'EdgeColor','none')
hold on
trisurf(Fp,PatWithCart(:,1),PatWithCart(:,2),PatWithCart(:,3),'facevertexcdata',PatPlot,'EdgeColor','none')
trisurf(Ft,TibWithCart(:,1),TibWithCart(:,2),TibWithCart(:,3),'facevertexcdata',TibPlot,'EdgeColor','none')
trisurf(FLatMen,LatMen(:,1),LatMen(:,2),LatMen(:,3),'facevertexcdata',MenPlot,'EdgeColor','none')
trisurf(FMedMen,MedMen(:,1),MedMen(:,2),MedMen(:,3),'facevertexcdata',MenPlot,'EdgeColor','none')
trisurf(FMPFL,MPFL(:,1),MPFL(:,2),MPFL(:,3),'FaceColor','c','EdgeColor','none')
trisurf(FsMCLp,sMCLp(:,1),sMCLp(:,2),sMCLp(:,3),'FaceColor','c','EdgeColor','none')
trisurf(FsMCLa,sMCLa(:,1),sMCLa(:,2),sMCLa(:,3),'FaceColor','c','EdgeColor','none')
trisurf(FPOL,POL(:,1),POL(:,2),POL(:,3),'FaceColor','c','EdgeColor','none')
trisurf(FALL,ALL(:,1),ALL(:,2),ALL(:,3),'FaceColor','c','EdgeColor','none')
trisurf(FLCL,LCL(:,1),LCL(:,2),LCL(:,3),'FaceColor','c','EdgeColor','none')
trisurf(FLPFL,LPFL(:,1),LPFL(:,2),LPFL(:,3),'FaceColor','c','EdgeColor','none')
trisurf(FOPL,OPL(:,1),OPL(:,2),OPL(:,3),'FaceColor','c','EdgeColor','none')
trisurf(FPP,PP(:,1),PP(:,2),PP(:,3),'FaceColor','c','EdgeColor','none')
trisurf(FACL,ACL(:,1),ACL(:,2),ACL(:,3),'FaceColor','y','EdgeColor','none')
trisurf(FPCL,PCL(:,1),PCL(:,2),PCL(:,3),'FaceColor','y','EdgeColor','none')
axis equal;light;material dull;