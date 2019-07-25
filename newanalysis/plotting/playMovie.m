
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
        frames = reshape(frames,exp.siz(1),exp.siz(2),exp.numframes);
        for i = 1:size(frames,3)
        %imshow(label2rgb(frames(:,:,i)))
        imagesc(frames(:,:,i))
        title(num2str(i))
        drawnow
        end
       
end



end