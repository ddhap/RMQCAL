%{
x=[1,2,3,4,5;2,1,3,5,4];
y=[1,2,3,4,5];
[dist] = SpearDist(x,y);
%}

function [dist] = SpearDist(x,y)

% Calculate the normalized Spear distance or number of discordant pairs between
% two rankings, x and y.  Rankings are compared between the columns of x
% and y.  X can be a vector or a matrix.

sizeData = size(x);
dist = zeros(sizeData(1),1);
numElements = sizeData(2);
% numPairs = numElements*(numElements-1)/2;

% Check for discordant pairs in the between the two input vectors 
tmp=nan(1,numElements);
for j=1:sizeData(1)
for i = 1:numElements
   tmp(1,i)=abs(x(j,i)-y(1,i));  
end   
dist(j,1)=sum(tmp); 
end