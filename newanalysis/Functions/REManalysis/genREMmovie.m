
 function allREMframes = genREMmovie(power_ratio, exp);% siz, thresh, validPixelIdx, save, filenameparams)%filenamebase, trez, fqrez)
 %PURPOSE:
    %Generates a tif movie of pixel desynchronization over the field of view
    
    %INPUT:
        %power_ratio: 
        % siz: the size of the FRAME (e.g., if the movie was originally
        % 128x128 then siz = [128, 128]
        % thresh: the value of the threshold to be used (see stdmat)
        % validpixelidx: the list of the subset of pixels in frame that
        % have activity
        % save: do you want to save the movie
        % filenameparams: cell calss with 1: a base name, 2: the time resolution, 3: the
        % frequency resolution
    %OUTPUT:
 
    siz = exp.siz;
    thresh = exp.thresh;
    validPixelIdx = exp.validPixelIdx;
    saveSynchClusterMovie = exp.saveSynchClusterMovie;
 
     filenamebase = exp.expDataFolder;
    trez = exp.timerez;
    fqrez = exp.freqrez;
 
 
 switch exp.method
     case 'bandpass'
     %power_ratio(power_ratio >= thresh) = 0;
     power_ratio(power_ratio <= thresh) = 0;
     case 'highpass'
     power_ratio(power_ratio <= thresh) = 0;
 end
    
 array = zeros(siz);
 array(validPixelIdx) = 1;
 
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


 moviefilename = [filenamebase exp.name '_REMMovieDataFile_Trez=' num2str(trez) '_Fqrez=' num2str(fqrez) '_pthresh=' num2str(thresh) exp.tag '.tif'];

 if saveSynchClusterMovie
     ['SAVING MOVIE' filenamebase]
   if exist( moviefilename, 'file') == 2
    delete(moviefilename);
   end
 end
 
 
 
 for i=1:size(power_ratio,2)
    array = zeros(siz);
    %array(validpixels) = 0.5;
    idx = find(power_ratio(:,i) ~= 0);
    activepixels = validPixelIdx(idx);
    array(activepixels) = 1;
    
    croppedframe = array(xmin:xmax, ymin:ymax);
    croppedframe(croppedframe < 1) = 0; 
    
    allREMframes(:,:,i) = croppedframe;
    
    if saveSynchClusterMovie; 
        imwrite(croppedframe,moviefilename,'WriteMode','append')
    end
 end

 
 
 
 end
