function [smoothpointsin] = smoothplot(Pointsin)

nrpoints = length(Pointsin);

% uit shortpathviapoints
Elastmatrix(:,1)=vertcat(1,(1:(nrpoints-2))',nrpoints);
Elastmatrix(:,2)=(1:nrpoints)';
Elastmatrix(:,3)=vertcat(1,(3:nrpoints)',nrpoints);

XYZtemp=Pointsin;

XYZtempnieuw=(XYZtemp(Elastmatrix(:,1),:)+XYZtemp(Elastmatrix(:,2),:)+XYZtemp(Elastmatrix(:,3),:))/3;
 XYZtempnieuw(1,:)=Pointsin(1,:);
 XYZtempnieuw(nrpoints,:)=Pointsin(nrpoints,:);

 smoothpointsin = XYZtempnieuw; 
end 