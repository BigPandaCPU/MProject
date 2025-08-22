function [vnew, fnew, Indices]=RepatchFromIndices(V,FLarge,Indices)

temp=double(ismember(FLarge,Indices));
tempy(:,1)=1:length(FLarge(:,1));
tempy(:,2)=sum(temp,2);
tempy=tempy(tempy(:,2)==3,:);

Fcut=FLarge(tempy(:,1),:);

numverticesOrig = (1:size(V,1))';
numverticestoremove=removerows(numverticesOrig,Indices);
numverticesnew=removerows(numverticesOrig,numverticestoremove);

[lia,loc]=ismember(numverticesOrig,numverticesnew,'rows');

fnew = loc(Fcut);
vnew=V(numverticesnew,:);
end