function img = imreadallraw(filename,x,y,nFrame,precision)

    % '*uint8' 8 bit imaging, raw data, behavioral camera
    % '*uint16' 16 bit imaging, raw data, VSD camera
    % '*float32' 32 bit, filtered data, VSD camera
    
    fid0 = fopen(filename, 'r', 'b');
    img_1 = fread(fid0,[x*y nFrame],precision);
    fclose(fid0);
  
    img_1 = reshape(img_1,x,y,nFrame);
    for ii=1:nFrame
        img(:,:,ii) = flipud(rot90(img_1(:,:,ii)));
    end
end
