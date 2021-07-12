addpath('/home/smith/Smith_Scripts/SmithJonkmanNatComm2021/CalciumImaging/');
addpath(genpath('/d1/studies/DLS_D2_Feb2018'));

directories=dir('/d1/studies/DLS_D2_Feb2018');
directories=directories(3:end-1,1);
list_dirs=struct2cell(directories)';
for i=1:length(directories)
    if ~exist(sprintf('%s/%s/VidFiles_msCam1', list_dirs{i,2}, list_dirs{i,1}), 'dir')
        try
    files=dir([directories(i,1).folder, '/', directories(i,1).name, '/*.avi']);
    processOnlyAVI(files)
        catch
            disp([list_dirs{i,2},'/' list_dirs{i,1}, ' could not process'])
        end
    else
        disp([list_dirs{i,2},'/' list_dirs{i,1}, ' already processed'])
    end
end




