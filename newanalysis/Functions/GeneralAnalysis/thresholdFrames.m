
 function [thresholdeddata, exp] = thresholdFrames(data, exp)
    %takes pixel values and thresholds them and returns the thresholded
    %values
    %INPUT
        % data: the array of data. Typically, it will of size
        % len(pixelValue)x numberofframes
        % siz: the size of the FRAME (e.g., if the movie was originally
        % 128x128 then siz = [128, 128]
        % thresh: the value of the threshold to be used (see stdmat)
        % validpixelidx: the list of the subset of pixels in frame that
        % have activity
        % stdmat: how do you want to threshold the movie?
            %some options: if stdmat is the matrix of pixel standard deviations then thresh
            %is essentially the number of standard deviations per pixel
            %if stdmat is just an arrays of 1, then thresh is a global
            %constant threshold value
    %OUTPUT
        % thresholdeddata: the frames of data that have been thresholded
        %newregion: similar to validpixelidx but contains the non-zero pixel indecies with respect to
        %the new cropped image.
        
        'Thresholding....'
        
        siz = exp.siz;
        thresh = exp.thresh;
        validpixelidx = exp.validPixelIdx;
        stdmat = exp.stdmat;

switch exp.threshstyle
    case 'pixelbypixel'       
        data(data <= thresh*stdmat) = 0;
    case 'constant'
        stdmat(stdmat > 0) = 1;
        data(data <= thresh*stdmat) = 0;
    case 'totalintensitystd'
        intensity =  mean(data);
        stdval = std(intensity);
        stdmat(stdmat > 0) = 1*stdval;
        data(data <= thresh*stdmat) = 0;
        clear intensity stdval
end
 
 array = zeros(siz);
 array(validpixelidx) = 1;
 
 A = array;
 
 Ax = sum(A, 2);
 Ay = sum(A, 1);
 
 Ax(Ax > 0) = 1;
 Ay(Ay > 0) = 1;
 
 xvalid = find(Ax == 1);
 yvalid = find(Ay == 1);
 
 xmin = min(xvalid);
 xmax = max(xvalid);
 ymin = min(yvalid);
 ymax = max(yvalid);
 

 thresholdeddata = zeros(length(xmin:xmax), length(ymin:ymax));
 
 for i=1:size(data,2)
    array = zeros(siz);
    %array(validpixels) = 0.5;
    idx = find(data(:,i) ~= 0);
    activepixels = validpixelidx(idx);
    array(activepixels) = 1;
    
    croppedframe = array(xmin:xmax, ymin:ymax);
    
    %croppedframe(croppedframe < 1) = 0; 

    thresholdeddata(:,:,i) = croppedframe;

    
 end

 newregion = mean(thresholdeddata,3);
 newregion(abs(newregion)>0) = 1;
 
 exp.newregion = newregion;
 exp.siz = size(newregion);
 
 end
