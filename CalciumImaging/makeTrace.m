% code adopted from mark bucklin
function trace = makeTrace(rp, data)
        nObj = numel(rp); %number of ROIs
        sz = size(data);
        nFrames = sz(end);
        % RESHAPE VIDEO DATA FRAMES TO COLUMNS
        data = reshape(data, [sz(1)*sz(2), nFrames]);
        trace = nan(nFrames,nObj);
        for kRoi = 1:nObj
            pixIdx = rp(kRoi).PixelIdxList(:);
            trace(:,kRoi) = mean(data(pixIdx,:), 1)' ;
        end
end