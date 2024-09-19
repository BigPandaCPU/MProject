clear,clc,close all
%load EXAMPLE
target_file = '../data/3DC_stl/T10.stl';
[target, ftarget, n, name] = stlRead(target_file);

source_file = '../data/template_stl/T10.stl';
[source, fsource, n, name] = stlRead(source_file);



[error,Reallignedsource,transform]=rigidICP(target,source);
trisurf(ftarget,target(:,1),target(:,2),target(:,3),'facecolor','y','Edgecolor','none');
hold
light
lighting phong;
set(gca, 'visible', 'off')
set(gcf,'Color',[1 1 0.88])
view(90,90)
set(gca,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1]);
trisurf(fsource,source(:,1),source(:,2),source(:,3),'facecolor','m','Edgecolor','none');

figure

trisurf(ftarget,target(:,1),target(:,2),target(:,3),'facecolor','y','Edgecolor','none');
hold on
light
lighting phong;
set(gca, 'visible', 'off')
set(gcf,'Color',[1 1 0.88])
%view(90,90)
set(gca,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1]);
trisurf(fsource,Reallignedsource(:,1),Reallignedsource(:,2),Reallignedsource(:,3),'facecolor','m','Edgecolor','none');



