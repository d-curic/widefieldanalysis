function SaveFramesasTiff(frames, fname, options, exp)
%The reason valid pixelidx is input seperately (instead of calling it from
%exp structure for example, is that if you want to use this for the
%unfiltered movied, then validPixelIdx will be 128x128


numdimensions = ndims(frames);

switch numdimensions
    case 2
        for i = 1:exp.numframes
            frame = zeros(exp.siz);
            frame(exp.validPixelIdx) = frames(:,i);
            
            movie(:,:,i) = frame;
        end
        
    case 3
        movie = frames;
        
end


['saving filtered video as as ' fname ]
saveastiff(movie, fname, options);

end
