function [d8a, procstart, info] = processFirstVidFile2(fname)

try
	
   % LOAD FILE
	[data, info, tifFile] = loadTif(fname);
	
	% GET COMMON FILE-/FOLDER-NAME
	[fp,~] = fileparts(tifFile.fileName);
	[~,fp] = fileparts(fp);
	procstart.commonFileName = fp;
	nFiles = numel(tifFile);
	nTotalFrames = info(end).frame;
	fprintf('Loading %s from %i files (%i frames)\n', fname, nFiles, nTotalFrames);
	
	
	% RANDOMLY CHOOSE FRAMES TO REPRESENT SET AT EACH STAGE OF PROCESSING
	representativeFrameIdx = randi([1 nTotalFrames], [min([10 nTotalFrames]), 1]);
	procstart.procstep.order = {...
		'raw',...
		'illuminationcorrected',...
		'motioncorrected',...
		'spatialfiltered',...
		'normalized',...
		'compressed',...
		'roisegmented'};
	procstart.procstep.raw = data(:,:,representativeFrameIdx);
	
	
	% ------------------------------------------------------------------------------------------
	% FILTER & NORMALIZE VIDEO, AND SAVE AS UINT8
	% ------------------------------------------------------------------------------------------
	
	% PRE-FILTER TO CORRECT FOR UNEVEN ILLUMINATION (HOMOMORPHIC FILTER)
	[data, procstart.hompre] = homomorphicFilter(data);
	procstart.procstep.illuminationcorrected = data(:,:,representativeFrameIdx);
	
	% CORRECT FOR MOTION (IMAGE STABILIZATION)
	[data, procstart.xc, procstart.prealign] = correctMotion(data);
	procstart.procstep.motioncorrected = data(:,:,representativeFrameIdx);
	
	% SAVE CORRECTED VIDEO BEFORE FILTERING & RESCALING TO 8-BIT
	saveVidFile(data,info,tifFile);
	
	% FILTER AGAIN -> this was removed in Hua-an's final version. Some
	% better, some worse by looking at the trace
% 	data = spatialFilter(data);
% 	procstart.procstep.spatialfiltered = data(:,:,representativeFrameIdx);
% 	
% 	% NORMALIZE DATA -> dF/F
	[data, procstart.normpre] = normalizeData(data);
% 	procstart.procstep.normalized = data(:,:,representativeFrameIdx);
	% data = subtractRail2RailNoise(data);
	
	% SUBTRACT BASELINE
	% [data, procstart.lastFrame] = subtractBaseline(data);
	
	% LOW-PASS FILTER TO REMOVE 6-8HZ MOTION ARTIFACTS
	% [data, procstart.filtobj] = tempAndSpatialFilter(data);
	d8a = uint8(data .* (255/65535));
	procstart.procstep.compressed = data(:,:,representativeFrameIdx);
    
catch me
	getReport(me)
end
end
