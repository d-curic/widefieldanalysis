function frames = transformToFrames(X, exp)
%this is useful instead of reshape as the number of valid pixels is less than the mask shape.
% so it will fill out the masked out regions. 

for i = 1:exp.numframes
                frame = zeros(exp.siz);
                frame(exp.validPixelIdx) = X(:,i);
                
                frames(:,:,i) = frame;                
            end


end
