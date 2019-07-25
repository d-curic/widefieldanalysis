 
function [pixelIntensity, exp] = getPixelIntensities(exp)%, numframes)
    %DISCRIPTION: finds the movie of the experiment and collects the pixel values into
    %an array
    %INPUT: the file name and the number of frames the movie is to be
            %(optional) numframes: if you want to overide the number of
            %frames to be read. By default it reads all of them. 
    %OUTPUT: %pixelIntensity: an array of size length(validpixels)xnumframes
             %that has the pixel values
             %pixelValue: array of size length(validpixels) that has the
             %location of valid pixels. Validpixels are those which are
             %within the mask region.
             %siz: the size of the frames eg. [128 128]
             %numframes: returns number of frames
             %stdmat: returns matrix of pixel standard deviations
    
             'Getting Pixel Values ... '
  
        
 infoimage = imfinfo(exp.videolocation);
 widthImg = infoimage(1).Width;
 heightImg = infoimage(1).Height;
 
 
 siz= [heightImg, widthImg];
 
defaultnumframes = length(infoimage);
 

 %set up the number of frames
 %'all' uses all available frames
 % if exp.callframes contains only one element, assume its an upperbound
 %if exp.callframes contains 2 elements
    %if second element is Inf, use default upperbound
    %if second element is finite value, use it as the upperbound.
 if strcmp(exp.callframes, 'all') 
     start = 1; stop = defaultnumframes; 
 elseif length(exp.callframes) ==1 
    start = 1; stop = exp.callframes;
 elseif length(exp.callframes) ==2 
    start = exp.callframes(1);
    if exp.callframes(2) ~= Inf
        stop = exp.callframes(2);
    else
        stop = defaultnumframes;
    end
 end
 
 framesList = start:stop;
 numframes = length(framesList);
 
 ['first frame ' num2str(start) ', last frame' num2str(stop), ' number of frames ' num2str(numframes)]
             
             frame = Tiff(exp.videolocation,'r');

             
             
%for i = 1:numframes
k = 1;
for i = framesList
    setDirectory(frame, i)
    
    subimage = frame.read();

    if isfield(exp, 'imageOffset') %sometimes it is useful to offset the image by a constant value. 
        subimage = subimage + exp.imageOffset;
    end
    
    if k ==1; 
        pixels = find(abs(subimage) > 0);
    end
    
    for j = 1:length(pixels)
        pixelIntensity(j,k) = subimage(pixels(j));
        validPixelIdx(j) = pixels(j); %this is the pixel location
    end
    
    k = k+1;
end
if class(pixelIntensity) ~= 'double'
    pixelIntensity = double(pixelIntensity);
end
stdmat = (var(pixelIntensity,0, 2)).^(1/2);


 exp.siz = siz;
 exp.numframes = numframes;
 exp.validPixelIdx = validPixelIdx;
 exp.stdmat = stdmat;
 
end