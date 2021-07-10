function vfile = saveVidFile(data,~,tifFile)
[expDir, expName] = fileparts(tifFile.fileName);
%vidFileDir = [expDir, '\', 'VidFiles'];
%AD edit 
vidFileDir = sprintf('%s/VidFiles_%s', expDir, expName);
if ~isdir(vidFileDir)
	mkdir(vidFileDir);
end
vidFileName = fullfile(vidFileDir,expName);
vfile = writeBinaryData(data, vidFileName);
end