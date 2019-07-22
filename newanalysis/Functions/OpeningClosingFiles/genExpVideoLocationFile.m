function genExpVideoLocationFile(project, name)
    %creates a file in the /data/ directory of the experiment with the
    %location of the video that corresponds to that experiment.
    
    expFile = [project.folder 'projectFiles/' name '.exp'];
    exp = loadExperiment(expFile, 'pbar', 0)
    
    videolocation = exp.handle;
    exp.folder
    fname = [exp.folder 'data/videolocation_' exp.name '.txt'];
    fid = fopen(fname, 'wt')
    ['saving video location to ' videolocation]
    fprintf(fid, videolocation);
    fclose(fid);
end