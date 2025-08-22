% SelectFaces
function Fselected = SelectFaces(Foriginal,Indices)

Fnew1 = zeros(length(Foriginal),1); 
Fnew2 = zeros(length(Foriginal),1); 
Fnew3 = zeros(length(Foriginal),1); 

for i = 1:length(Indices)
    Fnew1 = Fnew1 | (Foriginal(:,1) == Indices(i,1)); 
    Fnew2 = Fnew2 | (Foriginal(:,2) == Indices(i,1));
    Fnew3 = Fnew3 | (Foriginal(:,3) == Indices(i,1));
end 

Fnew = Fnew1 & Fnew2 & Fnew3; 
Fselected = Foriginal(Fnew==1,:); 

end 