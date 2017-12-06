function [dist] = KendallDist(x,y)

% Calculate the normalized Kendall Tau distance or number of discordant pairs between
% two rankings, x and y.  Rankings are compared between the columns of x
% and y.  X can be a vector or a matrix.

sizeData = size(x);
dist = zeros(sizeData(1),1);
numElements = sizeData(2);
% numPairs = numElements*(numElements-1)/2;

% Check for discordant pairs in the between the two input vectors 
for i = 2:numElements
    for j = 1:(i-1)
        dist = dist + double(sign(x(:,i)-x(:,j)) == -sign(y(:,i)-y(:,j)));
    end
end   
end

