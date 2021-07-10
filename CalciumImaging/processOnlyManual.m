%original written by Mark. Heavily modified from ``pfgc'' by Mike
function processOnlyManual(varargin)
if nargin
	fname = varargin{1};
	switch class(fname)
		case 'char'
			fileName = cellstr(fname);
		case 'cell'
			fileName = cell(numel(fname),1);
			for n = 1:numel(fname)
				fileName{n} = which(fname{n});
			end
		case 'struct'
			fileName = {fname.name}';
			for n = 1:numel(fileName)
				fileName{n} = which(fileName{n});
			end
	end
	[fdir, ~] = fileparts(which(fileName{1}));
else
	[fname,fdir] = uigetfile('/d1/studies/*.tif','MultiSelect','on');
	cd(fdir)
	switch class(fname)
		case 'char'
			fileName{1} = [fdir,fname];
		case 'cell'
			fileName = cell(numel(fname),1);
			for n = 1:numel(fname)
				fileName{n} = [fdir,fname{n}];
			end
    end
    %AD edits -- add the selected file to the path
    addpath(pwd);
end


nFiles = numel(fileName);
tifFile = struct(...
	'fileName',fileName(:),...
	'tiffTags',repmat({struct.empty(0,1)},nFiles,1),...
	'nFrames',repmat({0},nFiles,1),...
	'frameSize',repmat({[1024 1024]},nFiles,1));
HWAITBAR = waitbar(0, 'Aquiring Information from Each TIFF File');
for n = 1:nFiles
	HWAITBAR = waitbar(n/nFiles, HWAITBAR, 'Aquiring Information from Each TIFF File');
	tifFile(n).fileName = fileName{n};
	tifFile(n).tiffTags = imfinfo(fileName{n});
	tifFile(n).nFrames = numel(tifFile(n).tiffTags);
	tifFile(n).frameSize = [tifFile(n).tiffTags(1).Height tifFile(n).tiffTags(1).Width];
end

nTotalFrames = sum([tifFile(:).nFrames]);
fileFrameIdx.last = cumsum([tifFile(:).nFrames]);
fileFrameIdx.first = [0 fileFrameIdx.last(1:end-1)]+1;
[tifFile.firstIdx] = deal(fileFrameIdx.first);
[tifFile.lastIdx] = deal(fileFrameIdx.last);

% ------------------------------------------------------------------------------------------
% PROCESS FIRST FILE
% ------------------------------------------------------------------------------------------
[d8a, procstart, info] = processFirstVidFile(tifFile(1).fileName);
vidStats(1) = getVidStats(d8a);
vidProcSum(1) = procstart;
vfile = saveVidFile(d8a,info, tifFile(1));
allVidFiles{1} = vfile;
%ad edit
close(HWAITBAR);


% ------------------------------------------------------------------------------------------
% PROCESS REST OF FILES
% ------------------------------------------------------------------------------------------
vidStats(numel(tifFile),1) = vidStats(1);
vidProcSum(numel(tifFile),1) = vidProcSum(1);
allVidFiles{numel(tifFile),1} = [];
for kFile = 2:numel(tifFile)
	fname = tifFile(kFile).fileName;
	fprintf(' Processing: %s\n', fname);
	[f.d8a, procstart, f.info] = processVidFile(fname, procstart);
	vidStats(kFile) = getVidStats(f.d8a);
	vidProcSum(kFile) = procstart;
	vfile = saveVidFile(f.d8a, f.info, tifFile(kFile));
	allVidFiles{kFile,1} = vfile;
	info = cat(1,info, f.info);
end
for n = 1:numel(fileName)
uniqueFileName = procstart.commonFileName;
	saveTime = now;
	processedVidFileName =  ...
		['Processed_VideoFiles_',...
		uniqueFileName,'_',...
		datestr(saveTime,'yyyy_mm_dd_HHMM'),...
		'.mat'];
	processedStatsFileName =  ...
		['Processed_VideoStatistics_',...
		uniqueFileName,'_',...
		datestr(saveTime,'yyyy_mm_dd_HHMM'),...
		'.mat'];
	processingSummaryFileName =  ...
		['Processing_Summary_',...
		uniqueFileName,'_',...
		datestr(saveTime,'yyyy_mm_dd_HHMM'),...
		'.mat'];
	save(fullfile(fdir, processedVidFileName), 'allVidFiles');
	save(fullfile(fdir, processedStatsFileName), 'vidStats', '-v6');
	save(fullfile(fdir, processingSummaryFileName), 'vidProcSum', '-v6');
end
    
end
