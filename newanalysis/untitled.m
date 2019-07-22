close all
clear all
pwd
addpath(genpath([pwd '/Functions']))
project = setupProject('maindir.txt');


%%

%when running a new pipeline, this is the main thing you want to change

 exp.FR = project.defaultFPSoptionsCurrent.frameRate;
 exp.timerez = 2.5;
 exp.thresh = 0;
 exp.callframes = 'all';
 exp.threshstyle = 'pixelbypixel';

  exp.allGroups = {
{'mouse1', 'mouse2'}, [2 2 2 2 1 1 1 1];
{'1', '2', '3', '4'}, [1 1 2 2 3 3 4 4]  ;
{'dead' 'alive'}, [2 2 1 1 1 1 2 2];
};

exp.chosenGroups = [1 1 1];
exp.postselectGroups = {'dead'};
 
extradirname = '';

 project.checkedExperiments = ones(1,length(project.experiments));
%% 



for alivedead = ["dead", "alive"]
    exp.postselectGroups = {char(alivedead)};

for style = ["pixelbypixel", "constant", "totalintensitystd"]
    exp.threshstyle = char(style);
        
    if style == "constant"; th = 0:.05:.5; end
    if style == "pixelbypixel"; th = 0:.5:2.5; end
    if style == "totalintensitystd"; th = 0:.5:2.5; end

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
for k = 1:length(Stats)
    S = Stats{k};
    exp.thresh = th(k);
    for sname = ["size", "activity", "duration"]
        close all
        statname = char(sname);
        groupedstatistics = gatherGroupStatistics(S, grabstatid(statname), exp, project);
        plotgroupedstatistics(groupedstatistics, statname, exp, project,'',extradirname);
    end
    
end
clear Stats S
end
end








 

