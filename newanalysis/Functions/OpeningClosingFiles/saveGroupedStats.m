
function saveGroupedStats(groupedStats, project, statname, extradirname, exp)

    figuredir = [project.folder 'results/ClusterAnalysis/' extradirname exp.threshstyle '/']; 
    figuredir = [figuredir cell2mat(exp.postselectGroups) '/' statname '/'];    

    
       if ~exist(figuredir, 'dir');
        mkdir(figuredir);
    end
    
    ['Saving REM statistics to ... ' figuredir]
    
    filename = [figuredir 'GroupedREMStats_thr_' num2str(exp.thresh) '_stat' statname '_'];
    filename = [filename 'method_' exp.method '_trez' num2str(exp.timerez) '.mat'];
    
    save(filename, 'groupedStats')
end

