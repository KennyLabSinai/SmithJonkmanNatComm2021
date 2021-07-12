%% Written by Alexandra Difeliceantonio & Michael Romano
   %Extract traces from videos
    clear
    %select video
    [vidname,viddir] = uigetfile('/d1/studies/*.*','MultiSelect','on', 'Select ALL files');
    disp(['Loading data file ',(viddir),' -- could take a few minutes']);
    data=getData(fullfile(viddir, vidname));
    frameMax = max(data,[],3);
    frameMin = min(data,[],3);
    mmm = frameMax-frameMin;
    %select the ROIs
    rois= selectSingleFrameRoisNew(mmm, viddir);
    %Extract traces from ROIs
    R = processROIsFromVids(rois, vidname, viddir);
    %Get frame rate information
    framerate = inputdlg('Enter frame rate (frames/sec)','input',1);
    framerate =str2num(framerate{1,1});
    %create a timestamp variable
    for time=1:length(R(1).Trace)
        R(1).Time(time,1)=time/framerate;
    end
    for roi=2:length(R)
        R(roi).Time=R(1).Time;
    end
    %Create deltaF/F
    for roi=1:length(R)
         meanFlor=mean(R(roi).Trace);
        for time=1:length(R(1).Trace)
            R(roi).Deltaf(time,1)=(R(roi).Trace(time,1)-meanFlor)/meanFlor;
        end
    end
    save(sprintf('%s/traces_R.mat',viddir), 'R')
    
    [unselectedIndices, selectedIndices] = markBadTraces([R(1).Time]', [R.Deltaf]);
    clean_R=R;
    clean_R(selectedIndices)=[];
    save(sprintf('%s/cleaned_traces_R.mat',viddir), 'clean_R')
    
    
    for roi=1:length(clean_R)
        allrois_offset(:,roi)=clean_R(roi).Deltaf(:,1)+(roi*0.25);
    end
    trace_figure=figure('Name', 'Traces');
    plot(clean_R(1).Time, allrois_offset);
    print(trace_figure, [viddir, 'Traces'], '-dpdf');
    
   
    clear
    
    
    
