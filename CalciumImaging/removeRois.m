% written by mike
function Rout = removeRois(R, singleFrame)
    currFig = figure;
    Min = 0; Max = 100;
  H = imshow(singleFrame, [Min Max]); title('Select rois for this video');
    Rout = R;
    Rlines = cell(length(R),1);
    hold on
    for rId = 1:length(R)
        Rlines{rId} = plot(R(rId).BoundaryTrace.x, R(rId).BoundaryTrace.y,'--r', 'LineWidth',1.5);
    end
    hold off

 
    while(true)
        answer = inputdlg({'Min','Max'}, 'Contrast',1,{num2str(Min),num2str(Max)});
        Min = str2double(answer{1});
        Max = str2double(answer{2});
        figure(currFig)
        imshow(singleFrame, [Min Max]); 
        hold on

        for rId = 1:length(R)
            Rlines{rId} = plot(R(rId).BoundaryTrace.x, R(rId).BoundaryTrace.y,'--r', 'LineWidth',1.5);
        end
        hold off
        button = questdlg('Is this okay?',...
                'Keep ROI','Yes','No','Yes');
        if strcmp(button,'Yes')
            break
        else
            continue
        end
    end
    
    sz = size(singleFrame);
    mb = msgbox('Zoom to desired area');
    hold on
    while(true)
        zoom
        pause
        [xList,yList] = getpts;
        for inputs=1:length(xList)
            for roi=length(Rout):-1:1
                if roi_is_match(Rout(roi), [round(yList(inputs)) round(xList(inputs))], [sz(2) sz(1)])
                    Rout(roi) = [];
                    delete(Rlines{roi}); Rlines(roi) = [];
                end
            end
            
        end
        button = questdlg('Would you  like to remove more rois?','More rois?','Yes','No','Yes');
        if ~strcmp(button,'Yes')
            break
        end
    end
    
    
end


function out = roi_is_match(R, loc,dims)
i = zeros(dims);
i(loc(1),loc(2)) = 1;
centroid_loc = find(i);
if any(R.PixelIdxList == centroid_loc)
    out = true;
    return
end
out = false;
end
