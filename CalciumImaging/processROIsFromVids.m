function R = processROIsFromVids(R, filenames, viddir)
    filenames = sort_fnames(filenames);
    traces = [];
    for f=1:numel(filenames)
        %add the directory so it can find the file
        currfile = [viddir, filenames{f}];
        fprintf('Loading data from %s \n',currfile);
        d = getData(currfile); % load data from file
        traces_temp = makeTrace(R,d); % make a trace using these rois and these data
        traces = cat(1,traces,traces_temp);
    end
    for r=1:numel(R)
        R(r).Trace=traces(:,r);
    end


end



function fnames = sort_fnames(fnames)
if ~iscell(fnames)
    fnames={fnames};
else  
end
pattern = '.*_([0-9]+)\.[0-9]+\.[0-9]+\.[0-9]+\.uint(?:8|16)';
no = nan(length(fnames),1);
for i=1:length(fnames)
    [~,tok] = regexp(fnames{i},pattern,'match','tokens');
    no(i) = str2double(tok{1});
end
[~,i] = sort(no);
fnames = fnames(i);
end
