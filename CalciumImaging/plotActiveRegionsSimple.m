% plot_ascending
% all arrays supplied in N x samples
function [H, surfaceCell] = plotActiveRegionsSimple(taxis, traces, activeRegionBinaryMatrix)
    map = [0 0 1; 1 0 0];
    taxis = taxis(:)';
    maxVal = max(traces(:));
    z = zeros(size(taxis));
    numTraces = size(traces,1);
    surfaceCell = cell(numTraces,1);
    for wind=1:1:numTraces
        if wind > numTraces
            break
        end
        d = max(abs(traces(wind,:)));
        %help from here for the collowing:
        %https://www.mathworks.com/matlabcentral/answers/5042-how-do-i-vary-color-along-a-2d-line
        %(answer by Loginatorist)
        if nargin > 2
            if size(traces,1) == 1
                surfaceCell{wind} = surface([taxis;taxis], [traces(wind,:);traces(wind,:)], ...
                [z;z],[cast(activeRegionBinaryMatrix(wind,:),'uint8');cast(activeRegionBinaryMatrix(wind,:), 'uint8')],...
                'facecol','no',...
                'edgecol','interp',...
                'CDataMapping', 'scaled');
                colormap(map)
            else
                surfaceCell{wind} = surface([taxis;taxis], [traces(wind,:)+wind;traces(wind,:)+wind], ...
                [z;z],[cast(activeRegionBinaryMatrix(wind,:),'uint8');cast(activeRegionBinaryMatrix(wind,:), 'uint8')],...
                'facecol','no',...
                'edgecol','interp',...
                'CDataMapping', 'scaled');
                colormap(map)
            end
        else
            plot(taxis, traces(wind,:)+wind,'b');
            hold on;
        end

    end
    H = gcf;
    
end
