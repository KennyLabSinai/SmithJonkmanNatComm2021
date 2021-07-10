function Xout = movingaverage(X,width) %may have had help from here? http://matlabtricks.com/post-11/moving-average-by-convolution
wind = ones(width*2+1,1)/(width*2+1);
Xout = zeros(size(X));
for r=1:size(X,2)
    currX = X(:,r);
    currX = [flipud(currX(1:width)); currX; flipud(currX(end-width+1:end))];
    tempX = conv(currX, wind, 'same');
    Xout(:,r) = tempX(width+1:end-width);
end
end