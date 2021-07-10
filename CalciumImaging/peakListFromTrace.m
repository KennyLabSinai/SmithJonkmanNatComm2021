% written by Mike
function [peakList] = peakListFromTrace(trace, stdThreshold)
    traceFilt = removeMAMin(trace, 10, 500); %In vivo two-photon imaging of sensory-evoked dendritic calcium signals in cortical neurons
    peakList = identifyPeakIndices(traceFilt, zeros(size(traceFilt)), stdThreshold);
    meanNoPeak = mean(traceFilt(~peakList));
    stdNoPeak = std(traceFilt(~peakList));
    peaks = activeSegments(peakList(:)); 
    [peakStarts, peakEnds] = exceedsMinThreshold(traceFilt, peaks{1}(:,1), peaks{1}(:,2), meanNoPeak+5*stdNoPeak);
    peakListStartAndEnd = generateBinoFromStartAndEnd(traceFilt, peakStarts, peakEnds);
    peakList = risingPhase(trace(:),peakListStartAndEnd(:));

    
end
