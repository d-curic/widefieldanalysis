function [pixelIntensity, exp]  = pixelIntensitiesPipeline(project, exp, iexp)

%for iexp = 1:length(project.experiments)
    %if ~project.checkedExperiments(iexp); continue; end
    exp.videolocation = getVideoLocation(project, iexp);
    exp.expDataFolder = [project.folder project.experiments{iexp} '/data/'];
    exp.expResultsFolder = [project.folder project.experiments{iexp} '/Results/'];
   
    [pixelIntensity, exp] = getPixelIntensities(exp);
    
    if exp.randomizepixID
        'Randomizing Pixels!'
        pixelIntensity = pixelIntensity(randperm(size(pixelIntensity, 1)), :);
    end
    
    if exp.cyclicallypermute
       'Doing cyclic permutations!'
       
       s = size(pixelIntensity);
       for i = 1:s(1)
          pixelIntensity(i,:) = circshift(pixelIntensity(i,:), randi(s(2))); 
       end
       
    end

end