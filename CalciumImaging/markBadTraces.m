% some code modified from https://gist.github.com/cholland29/3107790
function [unselectedIndices, selectedIndices] = markBadTraces(taxis, traces) % taxis is a vector of times; traces is a time point x samples matrix
    selectedIndices = [];
    % following function modified from https://gist.github.com/cholland29/3107790
    function OnClickAxes(hax, ~)
        point1 = get(hax,'CurrentPoint'); % corner where rectangle starts ( initial mouse down point )
        rbbox
        point2 = get(hax,'CurrentPoint'); % corner where rectangle stops ( when user lets go of mouse )

        % Now lets iterate through all lines in the axes and extract the data that lies within the selected region
        allLines = findall(hax,'type','line');
        allLines = flipud(allLines);
       dataInd = getDataInRect(point1(1,1:2), point2(1,1:2), allLines); % not interested in z-coord
       selectedIndices = [selectedIndices; dataInd(:)];
    end
    % code heavily modified from https://gist.github.com/cholland29/3107790
    function dataInd = getDataInRect(point1, point2, line)
        startX = min(point1(1),point2(1));
        finX = max(point1(1), point2(1));

        startY = min(point1(2),point2(2));
        finY = max(point1(2),point2(2));
        
        xDataInd = ((line(1).XData(1,:) >= startX) & (line(1).XData(1,:) <= finX));
        dataInd = [];
        for l=1:numel(line)
            yDataInd = ((line(l).YData(1,:) >= startY) & (line(l).YData(1,:) <= finY));
            if any(yDataInd & xDataInd)
                dataInd(end+1) = l;
                fprintf('#%.0f;\n',dataInd);
            end
        end
    end
    figure;
    maxVal = max(traces(:));
    [H, tracecell] = plotAllTraces(taxis, (traces/maxVal));
    title(['Select traces to exclude from data. Press enter to move to next.']);
    set(H.Children(1), 'ButtonDownFcn',@OnClickAxes);
    for lim=0:3:(length(tracecell))
        ylim([lim-.5 lim+2.5]);
        pause
    end
    selectedIndices = unique(selectedIndices);
    unselectedIndices = setdiff(1:size(traces,1), selectedIndices);
end

function [H,tracecell]=plotAllTraces(taxis, traces)
hold on;
tracecell = cell(size(traces,2),1);
for i=1:size(traces,2)
    tracecell{i} = plot(taxis,traces(:,i)+i,'b');
end
H = gcf;
hold off
end

