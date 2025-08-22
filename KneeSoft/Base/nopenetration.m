function [VLatMen0,FLatMen]=nopenetration(VLatMen0,FLatMen,Vf,Ff)

TRf = triangulation(Ff,Vf);
normalsf = vertexNormal(TRf);

t1=VLatMen0(1,:);
t2=VLatMen0(end,:);

[idx,d]=knnsearch(Vf,VLatMen0);
d(d<0.0001)=0.0001;

 vectors=VLatMen0-Vf(idx,:);
    unitvector=horzcat(vectors(:,1)./d,vectors(:,2)./d,vectors(:,3)./d) ;
    control=sign((unitvector(:,1)-normalsf(idx,1)).^2+ (unitvector(:,2)-normalsf(idx,2)).^2+(unitvector(:,3)-normalsf(idx,3)).^2-2);
    distancestoplanes=abs(sum(normalsf(idx,:).*vectors,2));
    
    signs=control.*distancestoplanes;
     verplaatsing=signs;
     verplaatsing=((sign(verplaatsing)+1)/2).*verplaatsing;
    VLatMen0=VLatMen0+horzcat(normalsf(idx,1).*verplaatsing,normalsf(idx,2).*verplaatsing,normalsf(idx,3).*verplaatsing);

end
