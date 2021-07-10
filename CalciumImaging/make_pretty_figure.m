     addpath('/d1/software/matlab2017a/toolbox/BU_CI/image_processing_nd/');  
    [tracename, tracedir]=uigetfile('/d1/studies/*.mat', 'Select .mat file with your traces');
    load([tracedir, tracename]);
    [vidname,viddir] = uigetfile('/d1/studies/*.uint16','MultiSelect','on', 'Select ALL video files');
    disp('Loading data file -- could take a few minutes');
    data=getData(fullfile(viddir, vidname));
    frameMax = max(data,[],3);
    frameMin = min(data,[],3);
    mmm = frameMax-frameMin;
    Min = min(min(mmm)); Max = max(max(mmm));
    imshow(mmm,[Min Max]);
    ax = gca;
    [overlay, trace_img] = plot_rois_with_traces(clean_R, ax);
    yticks(1:length(clean_R));
    ylim([0 length(clean_R)+1]);
    print(overlay, [viddir, 'Numbered_ROIs'], '-dpng');
    print(trace_img, [viddir, 'Numbered_ROIs'], '-dpdf');