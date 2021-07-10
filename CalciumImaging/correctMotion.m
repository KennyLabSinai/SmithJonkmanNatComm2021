function [data, xc, prealign] = correctMotion(data, prealign) %written by Mark, modified by Mike
sz = size(data);
nFrames = sz(3);
if nargin < 2
	prealign.cropBox = selectWindowForMotionCorrection(data,sz(1:2)./2);
	prealign.n = 0;
end
ySubs = round(prealign.cropBox(2): (prealign.cropBox(2)+prealign.cropBox(4)-1)'); % get y and x indices
xSubs = round(prealign.cropBox(1): (prealign.cropBox(1)+prealign.cropBox(3)-1)');
% croppedVid = gpuArray(data(ySubs,xSubs,:));
croppedVid = data(ySubs, xSubs,:); % same thing here
cropSize = size(croppedVid);
maxOffset = floor(min(cropSize(1:2))/10); % another offset: this is the offset is an offset from the edges of the cropped video
ysub = maxOffset+1 : cropSize(1)-maxOffset; % crop the cropped vid
xsub = maxOffset+1 : cropSize(2)-maxOffset; % crop the cropped vid
yPadSub = maxOffset+1 : sz(1)+maxOffset;  % gets indices following maxOffset
xPadSub = maxOffset+1 : sz(2)+maxOffset;  % gets indices following maxOffset

if ~isfield(prealign, 'template')
	vidMean = im2single(croppedVid(:,:,1));
	templateFrame = vidMean(ysub,xsub); % only get center of pixels in the cropped frame
else
% 	templateFrame = gpuArray(prealign.template);
    templateFrame = prealign.template;
end

offsetShiftx = size(templateFrame,2) + maxOffset; % shift for right edge of x direction. Should get us the CENTER of the xcorr map
offsetShifty = size(templateFrame,1) + maxOffset; % shift for top edge of y direction. Should get us the CENTER of the xcorr map

validMaxMask = [];
N = nFrames;
xc.cmax = zeros(N,1);
xc.xoffset = zeros(N,1);
xc.yoffset = zeros(N,1);

% ESTIMATE IMAGE DISPLACEMENT USING NORMXCORR2 (PHASE-CORRELATION)
for k = 1:N
	movingFrame = im2single(croppedVid(:,:,k));
    
    %if frame is empty, fill everything with nans and skip to the next
    %frame
    if all(movingFrame(:) == 0)
       xc.xoffset(k) = nan;
       xc.yoffset(k) = nan;
       data(:,:,k) = deal(nan);
       xc.cmax(k) = nan;
       continue
    end
    
	c = normxcorr2(templateFrame, movingFrame); % cross correlate the cropped cropped frame with the current frame
	
	% RESTRICT VALID PEAKS IN XCORR MATRIX
	if isempty(validMaxMask)
		validMaxMask = false(size(c));
		validMaxMask(offsetShifty-maxOffset:offsetShifty+maxOffset, offsetShiftx-maxOffset:offsetShiftx+maxOffset) = true;
	end
	c(~validMaxMask) = false;
	c(c<0) = false;
	
	% FIND PEAK IN CROSS CORRELATION
	[cmax, imax] = max(abs(c(:)));
	[ypeak, xpeak] = ind2sub(size(c),imax(1));
	xoffset = xpeak - offsetShiftx; % subtract the center of the xcorr map: get shift relative to cropped image
	yoffset = ypeak - offsetShifty; % subtract the center of the xcorr map: get shift relative to cropped image
	
	% APPLY OFFSET TO TEMPLATE AND ADD TO VIDMEAN
	adjustedFrame = movingFrame(ysub+yoffset , xsub+xoffset);
    
	nt = prealign.n / (prealign.n + 1);
	na = 1/(prealign.n + 1);
	templateFrame = templateFrame*nt + adjustedFrame*na;
	prealign.n = prealign.n + 1;
    
	xc.cmax(k) = gather(cmax);
	dx = gather(xoffset);
	dy = gather(yoffset);
	xc.xoffset(k) = dx;
	xc.yoffset(k) = dy;
	
	% APPLY OFFSET TO FRAME
	padFrame = padarray(data(:,:,k), [maxOffset maxOffset], 'replicate', 'both');
	data(:,:,k) = padFrame(yPadSub+dy, xPadSub+dx);
	
end
prealign.template = gather(templateFrame);

end