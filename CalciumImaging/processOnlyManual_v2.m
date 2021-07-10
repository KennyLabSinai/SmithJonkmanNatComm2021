% all code modified from Mark Bucklin pfgc

function processOnlyManual_v2(varargin)
fileName = chargin(varargin{:}); % get filenames
if isempty(fileName)
    disp('No valid filenames given');
    return
end

nFiles = numel(fileName);
tifFile = struct(...
	'fileName',fileName(:),...
	'tiffTags',repmat({struct.empty(0,1)},nFiles,1),...
	'nFrames',repmat({0},nFiles,1));
for n = 1:nFiles
	tifFile(n).fileName = fileName{n};
	tifFile(n).tiffTags = imfinfo(fileName{n});
	tifFile(n).nFrames = numel(tifFile(n).tiffTags);
end

%find out how many subvideos we need to make
MAX_FRAMES_PER_STEP = 4000;
%get file name out of cell
fileName_char=fileName{:,:};
n_vid = 1; % subvideo number
for kFile = 1:numel(tifFile)
    vidstats = struct();
    curr_nFrames = tifFile(kFile).nFrames; % get number of frames in current file
    fprintf('Loading %d frames from  %s \n', curr_nFrames, fileName{kFile}); 
    data = loadTif(tifFile(kFile).fileName); % load Tif file
    for f=1:MAX_FRAMES_PER_STEP:curr_nFrames
        curr_slice = data(:,:,f:min((f+MAX_FRAMES_PER_STEP-1),size(data,3))); % get a slice of data equal to MAX_FRAMES_PER_STEP
        if n_vid == 1 % if it is the first subvideo
            [curr_slice, procstart.hompre] = homomorphicFilter(curr_slice); %homomorphic filter
            [curr_slice, procstart.xc, procstart.prealign] = correctMotion(curr_slice); % correct motion
            saveVidFile(curr_slice,fileName_char, n_vid); % save it

            [curr_slice, procstart.normpre] = normalizeData(curr_slice);

            saveVidFile(curr_slice, tifFile(kFile).fileName, n_vid,1);

        else
             [curr_slice, procstart.hompre] = homomorphicFilter(curr_slice, procstart.hompre);
            [curr_slice, procstart.xc, procstart.prealign] = correctMotion(curr_slice,procstart.prealign);
            saveVidFile(curr_slice,fileName_char, n_vid);

            [curr_slice, procstart.normpre] = normalizeData(curr_slice, procstart.normpre);


            saveVidFile(curr_slice, tifFile(kFile).fileName, n_vid,1);

        end
        vidstats(f).stats = getVidStats(curr_slice);
        n_vid = n_vid + 1; % increment
    end
    [dir,nm] = fileparts(tifFile(kFile).fileName);
    if isempty(dir)
        dir = pwd;
    end
    save([dir '/video_statistics_' nm '.mat'],'vidstats');
end

end

function stats = getVidStats(data)

stats.max = max(data,[],3);
stats.min = min(data,[],3);
stats.mean = mean(data,3);


end


function fileName = chargin(varargin)

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


end

function vfile = saveVidFile(data,file_name, sub_no, normalized)
[expDir, expName] = fileparts(file_name);
%vidFileDir = [expDir, '\', 'VidFiles'];
%AD edit
if isempty(expDir)
    expDir = pwd;
end
vidFileDir = sprintf('%s/VidFiles_%s', expDir, expName);
if ~isdir(vidFileDir)
	mkdir(vidFileDir);
end
vidFileName = fullfile(vidFileDir,expName);
if nargin < 4 || ~normalized
vfile = writeBinaryData(data, [vidFileName '_subvideo_' num2str(sub_no)]);
else
vfile = writeBinaryData(data, [vidFileName '_normalized_subvideo_' num2str(sub_no)]);
end    
end
