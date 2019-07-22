
function playMovie(frames)

for i = 1:size(frames,3)
    %imshow(label2rgb(frames(:,:,i)))
    imagesc(frames(:,:,i))
    title(num2str(i))
    drawnow
end

end