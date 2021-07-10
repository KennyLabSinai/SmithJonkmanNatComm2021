% written by Mark, modified by Mike
function [d8a, procstart, info] = processVidFile(fname, procstart)

try
	% LOAD FILE
	[data, info, tifFile] = loadTif(fname);
	
	% GET COMMON FILE-/FOLDER-NAME
	nFiles = numel(tifFile);
	nTotalFrames = info(end).frame;
	fprintf('Loading %s from %i files (%i frames)\n', procstart.commonFileName, nFiles, nTotalFrames);
	
	
	% ------------------------------------------------------------------------------------------
	% FILTER & NORMALIZE VIDEO, AND SAVE AS UINT8
	% ------------------------------------------------------------------------------------------
	
	% PRE-FILTER TO CORRECT FOR UNEVEN ILLUMINATION (HOMOMORPHIC FILTER)
	[data, procstart.hompre] = homomorphicFilter(data, procstart.hompre);
	% CORRECT FOR MOTION (IMAGE STABILIZATION)
	[data, procstart.xc, procstart.prealign] = correctMotion(data, procstart.prealign);
	
	% SAVE CORRECTED VIDEO BEFORE FILTERING & RESCALING TO 8-BIT
	saveVidFile(data,info,tifFile);
	
	% FILTER AGAIN
	% data = homomorphicFilter(data);
% 	data = spatialFilter(data);
% 	
% 	% NORMALIZE DATA -> dF/F
	[data, procstart.normpre] = normalizeData(data, procstart.normpre);
	% data = subtractRail2RailNoise(data);
	% SUBTRACT BASELINE
	% [data, procstart.lastFrame] = subtractBaseline(data, procstart.lastFrame);
	% LOW-PASS FILTER TO REMOVE 6-8HZ MOTION ARTIFACTS
	% [data, procstart.filtobj] = tempAndSpatialFilter(data);
	% OUTPUTS
	d8a = uint8(data .* (255/(65535)));
catch me
	getReport(me)
end
end
