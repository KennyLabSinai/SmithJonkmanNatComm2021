% written by Mike
function [segments] = activeSegments(X)
    segments = cell(size(X,2),1);
    numRois = size(X,2);
    for roi=1:numRois
        x = X(:,roi);
        x(isnan(x)) = 0;
        startIsActive = (x(1) == 1);
        endIsActive = (x(end) == 1);
        offEvents = find(diff(x) == -1);
        onEvents = find(diff(x) == 1)+1;

        if startIsActive && ~isempty(offEvents)
            offEvents(1) = [];
        end
        if endIsActive && ~isempty(onEvents)
            onEvents(end) = [];
        end
        segments{roi} = [onEvents, offEvents];
    end
end
