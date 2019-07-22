function Stats  = clusterStatisticsPipeline(pixelIntensity, exp, iexp)

% for iexp = 1:length(project.experiments)
%     if ~project.checkedExperiments(iexp); continue; end
%     iexp
%     exp.videolocation = getVideoLocation(project, iexp);
%     exp.expDataFolder = [project.folder project.experiments{iexp} '/data/'];
%     exp.expResultsFolder = [project.folder project.experiments{iexp} '/Results/'];
%    
%     [pixelIntensity, exp] = getPixelIntensities(exp);
    
    [thresholdeddata, exp] = thresholdFrames(pixelIntensity, exp);
    clear pixelIntensity
    
    if exp.savethresholdmovie
        'saving thresholded movie...'
            options.overwrite = true;
            options.message = false;
            fname = [exp.expDataFolder exp.threshstyle '_' num2str(exp.thresh) exp.tag '.tif'];
            saveastiff(single(thresholdeddata), fname, options)
    end
    
 
    
    'clustering...'

    CC = bwconncomp(thresholdeddata);
    clear thresholdeddata
    [Stats, CC] = getClusterStatistics(CC, exp);
    clear CC    
%end 

end