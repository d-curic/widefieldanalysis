%close all
%clear all
pwd
addpath(genpath([pwd '/Functions']))
project = setupProject('maindir.txt');

resultdir = [project.folder 'results/PhaseSynch/'];

      if ~exist(resultdir, 'dir');
        mkdir(resultdir);
    end



 project.checkedExperiments = ones(1,length(project.experiments));


for iexp = 1:length(project.experiments)
    
    genExpVideoLocationFile(project, project.experiments{iexp})

end

%%


