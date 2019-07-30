project = setupProject('maindir.txt');

 exp.FR = project.defaultFPSoptionsCurrent.frameRate;
 exp.timerez = 2.5;
 exp.thresh = 0;
 exp.callframes = 'all';
 exp.threshstyle = 'pixelbypixel';
 exp.tag = '';
 exp.savethresholdmovie = false; 
 exp.randomizepixID = false;

    if exp.threshstyle == "constant"; th = 0:.05:.5; end
    if exp.threshstyle == "pixelbypixel"; th = 0:.5:4.5; end
    if exp.threshstyle == "totalintensitystd"; th = 0:.5:3; end
 

[uniquelabels, parsedlabels] = getUniqueLabels(project);
 
chosenlabels = uniquelabels;%{'AD','ctrl'};
exp.removeborderEvents = false;
if exp.removeborderEvents; exp.tag = ['noBrdrEvnts']; end

for i = 1:length(th(1))
    exp.thresh = th(i);
    stat = loadStats(th(i), project, exp);
    gatherPlotandSaveStats({stat}, chosenlabels, project, exp)
    clear stat
end






function gatherPlotandSaveStats(Stats, chosenlabels, project,exp)


for statname = ["size", "activity"];
    close all
    sname = char(statname);
    clear groupedStats
    groupedStats = Copy_of_groupStats(Stats, sname, chosenlabels, project,exp);


for i = 1:length(groupedStats)
    plotoptions.displayname = [chosenlabels{i} ', ' num2str(length(groupedStats{i})) ];
    plotoptions.scale = 0;
    if contains(chosenlabels{i}, 'AD'); 
        plotoptions.linestyle = '--'; 
        plotoptions.color = 'r';
    else
        plotoptions.linestyle = '-'; 
        plotoptions.color = 'b';
    end    
    plotoptions.xlabel = sname;
    plotoptions.ylabel = ['P(' sname ')'];
    plotoptions.title = [ sname '-' exp.threshstyle '-' num2str(exp.thresh) exp.tag ];
    plotoptions.showlegend = true;
    plotLog(groupedStats{i},50, plotoptions);
    hold on
    
end
clear groupedStats
filedir = [project.folder 'results/ClusterAnalysis/' exp.threshstyle '/' sname '/'];
checkifDirExists(filedir)
filename = [filedir sname '_' num2str(exp.thresh) exp.tag ]; 
saveas(gcf, [filename '.png'])
end
end

