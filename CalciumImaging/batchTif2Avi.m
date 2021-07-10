function batchTif2Avi( dirName )
%MSBATCHALIGNMENT Summary of this function goes here
%   Detailed explanation goes here
    dataFolders = batchFindTifFolders(dirName,[]);
    for folderNum = 1:length(dataFolders)
        currentFolder = dataFolders{folderNum};
        dirData = dir(currentFolder);
        dirIndex = [dirData.isdir];
        fileList = {dirData(~dirIndex).name};       
        for i = 1:length(fileList)
            fileTif = fileList{i};
            if (length(fileTif)>4)
                if (strcmp(fileTif((end-3):end),'.tif'))
                    display(['Working on alginment of ' currentFolder '. File= ' fileTif])
                    InfoImage=imfinfo(fileTif);
                    mImage=InfoImage(1).Width;
                    nImage=InfoImage(1).Height;
                    NumberImages=length(InfoImage)
                    
                    outputVideo = VideoWriter(fullfile(currentFolder,[fileTif(1:end-4) '.avi']),'Grayscale AVI');
                    outputVideo.FrameRate = 30;
                    open(outputVideo)
                    
                    frame=zeros(nImage,mImage,NumberImages,'uint16');
                    for frameNum = 1:NumberImages
                        frame = imread(fileTif,'Index',frameNum);
%                         imshow(frame,[0 2^12])
%                         drawnow()
                        writeVideo(outputVideo,uint8(double(frame)/2^12*2^8))
                        if (mod(frameNum,1000)==1)
                            display([num2str(frameNum/NumberImages*100) '% done.'])
                        end
                    end
                    close(outputVideo)
                end
            end
        end
    end
end

