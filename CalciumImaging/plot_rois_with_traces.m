function [fig1, fig2] = plot_rois_with_traces(R, ax)
    colorwheel = distinguishable_colors(numel(R), [1 1 1; 0 0 0] );
    hold on;
    for i=1:numel(R)
        plot(ax,R(i).BoundaryTrace.x,R(i).BoundaryTrace.y,'Color',colorwheel(i,:));
        hold(ax, 'on');
        text(ax,R(i).Centroid(1), R(i).Centroid(2),num2str(i),'Color','red');
        hold(ax,'on');
    end
    fig1 = gcf;
    figure;
    for i=1:numel(R)
        plot(rescale(R(i).Trace)+i-1, 'Color', colorwheel(i,:));
        hold on;
    end
    fig2 = gcf;
end

