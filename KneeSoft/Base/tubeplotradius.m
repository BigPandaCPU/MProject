function [varargout]=tubeplotradius(x,y,z,varargin)

subdivs = 6;

N=size(x,1);
if (N==1)
    x=x';
    y=y';
    z=z';
    N=size(x,1);
end

if (nargin == 3)
    r=x*0+1;
else
    r=varargin{1};
    if (size(r,1)==1 & size(r,2)==1)
        r=r*ones(N,1);
    end
end
if (nargin > 5)
    subdivs=varargin{3}+1;
end
if (nargin > 6)
    vec=varargin{4};
    [t,n,b]=frame(x,y,z,vec);
else
    [t,n,b]=frenet(x,y,z);
end




X=zeros(N,subdivs);
Y=zeros(N,subdivs);
Z=zeros(N,subdivs);

theta=0:(2*pi/(subdivs-1)):(2*pi);

for i=1:N
    X(i,:)=x(i) + r(i)*(n(i,1)*cos(theta) + b(i,1)*sin(theta));
    Y(i,:)=y(i) + r(i)*(n(i,2)*cos(theta) + b(i,2)*sin(theta));
    Z(i,:)=z(i) + r(i)*(n(i,3)*cos(theta) + b(i,3)*sin(theta));
end

if (nargout==0)
    if (nargin > 4)
        V=varargin{2};
        if (size(V,1)==1)
        	V=V';
        end
        V=V*ones(1,subdivs);
        surf(X,Y,Z,V);
    else
        surf(X,Y,Z);
    end
else
    varargout(1) = {X};
    varargout(2) = {Y};
    varargout(3) = {Z};
end

end