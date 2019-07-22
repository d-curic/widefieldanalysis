close all
clear all
addpath(genpath([pwd '/Functions']))
project = setupProject('maindir_5to6.txt');


%%

%when running a new pipeline, this is the main thing you want to change

 exp.FR = project.defaultFPSoptionsCurrent.frameRate;
 exp.timerez = 2.5;
 exp.thresh = 0;
 exp.callframes = [1000 4500];
 exp.threshstyle = 'pixelbypixel';
 exp.tag = 'filt';
 exp.savethresholdmovie = false; 
 exp.randomizepixID = false;
 
 if exp.randomizepixID; exp.tag = [exp.tag '_pixIDrand']; end

 [uniquelabels, parsedlabels] = getUniqueLabels(project);

chosenlabels = uniquelabels;%{"dead", "alive"};
 
 project.checkedExperiments = ones(1,length(project.experiments));
%% 




for style = [ "constant", "pixelbypixel", "totalintensitystd"]
    exp.threshstyle = char(style);
        
    if style == "constant"; th = 0:.025:.2; end
    if style == "pixelbypixel"; th = 0:.5:4.5; end
    if style == "totalintensitystd"; th = 0:.5:3; end

for iexp = 1:length(project.experiments)
	if ~project.checkedExperiments(iexp); continue; end

	[pixelIntensity, exp]  = pixelIntensitiesPipeline(project, exp, iexp);
    
    k = 1;
    for thh = th
        exp.thresh = thh;
        Stats{k}{iexp} = clusterStatisticsPipeline(pixelIntensity, exp, iexp);
        k=k+1;
    end
end

clear pixelIntensity

% 
for i = 1:length(Stats)
    exp.thresh = th(i);
    gatherPlotandSaveStats({Stats{i}}, chosenlabels, project, exp)
end
 clear Stats

end

%%


function gatherPlotandSaveStats(Stats, chosenlabels, project,exp)


for statname = ["size", "duration", "activity"];
    close all
    sname = char(statname);
    clear groupedStats
    groupedStats = groupStats(Stats, sname, chosenlabels, project);


for i = 1:length(groupedStats)
    plotoptions.displayname = [chosenlabels{i} ', ' num2str(length(groupedStats{i})) ];
    plotoptions.scale = 0;
    plotoptions.linestyle = '';
    plotoptions.color = '';
    plotoptions.xlabel = sname;
    plotoptions.ylabel = ['P(' sname ')'];
    plotoptions.title = [ sname '-' exp.threshstyle '-' num2str(exp.thresh) exp.tag ]
    plotLog(groupedStats{i},30, plotoptions)
    hold on
    
end
clear groupedStats
filedir = [project.folder 'results/ClusterAnalysis/' exp.threshstyle '/' sname '/'];
checkifDirExists(filedir)
filename = [filedir sname '_' num2str(exp.thresh) exp.tag ]; 
saveas(gcf, [filename '.png'])
end
end



 

