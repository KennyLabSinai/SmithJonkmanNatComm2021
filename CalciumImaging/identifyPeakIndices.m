%written by Mike
function peakPoints = identifyPeakIndices(trace, peakPoints, stdThreshold)
    currStd = std(trace(~peakPoints));
    if numel(find(trace > (mean(trace(~peakPoints))+currStd*stdThreshold))) == 0
        return
    else
        proposedPeakPoints = (peakPoints) | (trace > mean(trace(~peakPoints))+currStd*stdThreshold); 
        if length(find(proposedPeakPoints)) == length(find(peakPoints))
            return
        end
        peakPoints = identifyPeakIndices(trace, proposedPeakPoints, stdThreshold);
    end

end
