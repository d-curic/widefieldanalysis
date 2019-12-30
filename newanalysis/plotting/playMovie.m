
function playMovie(frames, exp)

numdimensions = ndims(frames);

switch numdimensions
    case 3
        for i = 1:size(frames,3)
            %imshow(label2rgb(frames(:,:,i)))
            imagesc(frames(:,:,i))
            title(num2str(i))
            drawnow
        end
    case 2
        
        %sometimes the frame data contains only values from the non-zero
        %pixel values. In this case a new frame must be made to accomodate
        %this. This is handled in the else statement.
        
        if prod(size(frames)) == prod(size(exp.mask))*exp.numframes
            frames = reshape(frames,exp.siz(1),exp.siz(2),exp.numframes);
            for i = 1:size(frames,3)
                %imshow(label2rgb(frames(:,:,i)))
                imagesc(frames(:,:,i))
                title(num2str(i))
                drawnow
            end
            
        else
            
            
            for i = 1:exp.numframes
                frame = zeros(exp.siz);
                frame(exp.validPixelIdx) = frames(:,i);
                imagesc(frame)
                title(num2str(i))
                drawnow
            end

        end
end



end
