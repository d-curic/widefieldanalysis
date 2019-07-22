function CropandSaveTiff(X, fname, options)
%The reason valid pixelidx is input seperately (instead of calling it from
%exp structure for example, is that if you want to use this for the
%unfiltered movied, then validPixelIdx will be 128x128

if ~strcmp(fname(end-3:end),'.tif')
   fname = [fname '.tif']; 
end

   if exist( fname, 'file') == 2
    delete(fname);
   end
 
   siz = size(X);
   
   array = zeros(siz);
 array(find(X(:,:,14)~=0)) = 1; %14 was arbitrary, just idnt want to use first frame just in case
 
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

 

 'Saving ...'
 for i=1:size(X,3)
    array = zeros(siz);
    array = X(:,:,i);
    
    croppedframe = array(xmin:xmax, ymin:ymax);
    
    croppeddata(:,:,i) = croppedframe;
 end

 ['saving filtered video as as ' fname ]
 saveastiff(croppeddata, fname, options);
 
end