% idea from "In vivo two-photon imaging of sensory-evoked dendritic 
% calcium signals in cortical neurons" by Jia et al. Nature Protocols. (2011)
function xout = removeMAMin(x, order, window_width) 
    xFilt = movingaverage(x,order);
    minlist = zeros(size(x));
    for i=1:length(x)
        searchStart = max(1,i-window_width);
        searchEnd = min(length(x),i+window_width);
        minlist(i) = min(xFilt(searchStart:searchEnd));
    end
    xout = x-minlist;
end