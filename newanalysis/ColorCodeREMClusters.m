%close all
%clear all
pwd
addpath(genpath([pwd '/Functions']))
project = setupProject('maindir.txt');


%%

 exp.FR = project.defaultFPSoptionsCurrent.frameRate;
 exp.freqrez = 2.5;
 exp.thresh = .25;
 exp.callframes = 'all';
 exp.threshstyle = 'pixelbypixel';
 exp.savePowerRatioData = false;
 exp.saveSynchClusterMovie = false;
 exp.OverlapPercent = 50;
 exp.randomizepixID = false;
 exp.cyclicallypermute = false;
 exp.tag = 'REM';
 
 if exp.randomizepixID; exp.tag = [exp.tag '-pixIDshufld']; end
 if exp.cyclicallypermute; exp.tag = [exp.tag '-cycperm']; end
 
 
 
 %exp.band1 = [0.5 2]; 
 %exp.band2 = [3 4];
 
 exp.band1 = [0.5 3.25]; 
 exp.band2 = [3.25 6];
 
 exp.freqlim = [0.5 6];
    
 exp.method = 'bandpass';%'bandpass';

 if isequal(exp.method, 'highpass');
     exp.timerez = 0.3;
     exp.freqlim = [0.5 25];
 end

 project.checkedExperiments = ones(1,length(project.experiments));

  exp.thresh = 1;
 
for iexp = 45%:2:length(project.experiments)
	if ~project.checkedExperiments(iexp); continue; end
    th = exp.thresh;
    exp.name = project.experiments{iexp};

    [allREMframes, msg, list] = loadBinaryMovie(project, exp);
    CC = bwconncomp(allREMframes);
   
end


%%

L = labelmatrix(CC);

for i = 1:size(L,3)
    ll = L(:,:,i);
    m = min(min(ll(ll>0)));
    M = max(max(ll(ll>0)));
    
    if ~isempty(m); climmin = m; end
    if ~isempty(M); climmax = M; end
        
    
    lmax(i) = climmax;
    imagesc(ll);
    title(num2str(i))
    colorbar
    caxis([climmin-1 climmax+1]);
    drawnow
   
end
%%
%plot(lmax)
