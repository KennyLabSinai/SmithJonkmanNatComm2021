
function [peakStartsOut, peakEndsOut] = exceedsMinThreshold(trace, peakStarts, peakEnds, threshold)
peakStartsOut = [];
peakEndsOut = [];
for peak=1:size(peakStarts,1)
    if max(trace(peakStarts(peak):peakEnds(peak))) > threshold
        peakStartsOut = [peakStartsOut, peakStarts(peak)];
        peakEndsOut = [peakEndsOut, peakEnds(peak)];
    end
end

end