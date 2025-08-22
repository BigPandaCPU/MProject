clear all;
close all;
clc
warning('off','MATLAB:triangulation:PtsNotInTriWarnId')
%% Input parameters
addpath('./InputData')
addpath('./Base');

%Load random structures
FemurStruct = load('data\aim_source\Femur_aim.mat');
Femur = FemurStruct.aim_source;

TibiaStruct = load('data\aim_source\Tibia_aim2.mat');
TibFib = TibiaStruct.aim_source_new;

% figure
% plot3(Femur(:,1), Femur(:,2),Femur(:,3),'r.')
% hold on
% plot3(TibFib(:,1), TibFib(:,2),TibFib(:,3),'g.')
% axis('equal')

%Load mean structures
load('InputData\MeanStructures.mat');

MedCartTib = load('MedCartTibMean.mat');
LatCartTib = load('LatCartTibMean.mat');
FemCart = load('FemCartMean.mat');

TibFibStruct = load('./data/aim_source/Tibia_model_registresed.mat');
TibFib = TibFibStruct.registered;

[FemWithCart,TibWithCart] = CartilageFemurTibiaPrediction(Femur,TibFib,...
                            MeanFemur,Ff,Ft,MedCartTib,LatCartTib,FemCart,...
                            1,'./data/stl');
list_femcart = ismember(Ff,FemCart.IndicesFemCart);
FemPlot = repmat([0.95 0.95 0.87],size(Ff,1),1);
FemPlot(sum(list_femcart,2)==3,:) = repmat([0.98 0.98 0.96],sum((sum(list_femcart,2)==3)),1);

list_tibcart = ismember(Ft,[MedCartTib.IndicesMedCart;LatCartTib.IndicesLatCart]);
TibPlot = repmat([0.95 0.95 0.87],size(Ft,1),1);
TibPlot(sum(list_tibcart,2)==3,:) = repmat([0.98 0.98 0.96],sum((sum(list_tibcart,2)==3)),1);


figure
trisurf(Ff,FemWithCart(:,1),FemWithCart(:,2),FemWithCart(:,3),'facevertexcdata',FemPlot,'EdgeColor','none')
axis equal;
h1 = light('Position',[1,0,-1],'Style','infinite');
% light
% lighting phong;

material dull;
xlabel('x')
ylabel('y')
zlabel('z')


figure
trisurf(Ft,TibWithCart(:,1),TibWithCart(:,2),TibWithCart(:,3),'facevertexcdata',TibPlot,'EdgeColor','none')
axis equal;
h2 = light('Position',[1,0,1],'Style','infinite');
% 
material dull;
xlabel('x')
ylabel('y')
zlabel('z')
