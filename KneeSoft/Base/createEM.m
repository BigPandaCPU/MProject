function [F]=createEM(a,b)

F=[];

for i=1:(a-1)
    temp=[i (a+i) (i+1) ; (a+i) (a+i+1) (i+1)];
    F=[F;temp];

end
F1=F;


for i=1:(b-2)
    temp=F1+(i)*a;
    F=[F;temp];
end
end