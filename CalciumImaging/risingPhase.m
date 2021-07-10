% pass in matrix of time points x roi traces and time points x roi traces
% activation state
function risingMat = risingPhase(traces, activationState)
    risingMat = zeros(size(traces));
    segments = activeSegments(activationState);
    for n=1:numel(segments)
        currROISegments = segments{n};
        for peak=1:size(currROISegments,1)
            currPeak = traces(currROISegments(peak,1):currROISegments(peak,2),n);
            [~,i] = max(currPeak);
            risingMat(currROISegments(peak,1):(currROISegments(peak,1)+i-1),n) = deal(1);
        end
    end
end