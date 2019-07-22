close all
clear all
pwd
addpath(genpath([pwd '/Functions']))
project = setupProject('maindir05to6.txt');


%%



 exp.FR = project.defaultFPSoptionsCurrent.frameRate;
 exp.timerez = .9;
 exp.thresh = .25;
 exp.callframes = 'all';
 exp.threshstyle = 'pixelbypixel';
 exp.savePowerRatioData = false;
 exp.saveSynchClusterMovie = true;
 
 exp.freqlim = [0.5 6];

     
 exp.method = 'bandpass';
 
 
  exp.allGroups = {
{'alive', 'dead'}, [2 2 2 2 1 1 1 1];
{'1', '2', '3', '4'}, [1 1 2 2 3 3 4 4]  ;
{'mouse1' 'mouse2'}, [2 2 1 1 1 1 2 2];
};

 exp.chosenGroups = [ 1 1 1];

extradirname = ['REM/' exp.method '/trialsgrouped/'];
if exp.chosenGroups(4) == 1; extradirname = ['REM/' exp.method '/seperatedbytrial/']; end 

 if isequal(exp.method, 'highpass');
     exp.timerez = 0.3;
     exp.freqlim = [0.5 25];
 end


 
 project.checkedExperiments = ones(1:length(project.experiments));

 th = .1%0.01:.25:.51;
 
for iexp = 1:length(project.experiments)
	if ~project.checkedExperiments(iexp); continue; end
    exp.name = project.experiments{iexp};
	[pixelIntensity, exp]  = pixelIntensitiesPipeline(project, exp, iexp);
    
    exp = getCroppedRegion(exp);

        k = 1;
    for thh = th
        exp.thresh = thh;
        ['using threshold ... ' num2str(exp.thresh);]
     [p_ratio, exp] = doREMAnalysis(pixelIntensity, exp);
     allREMframes = genREMmovie(p_ratio, exp);%siz, pthresh, pixelValue, validpixels, 0, true, [folder project.experiments{iexp}], timerez, freqrez)
    CC = bwconncomp(allREMframes);
    Stats{k}{iexp} = getClusterStatistics(CC, exp);
    k = k+1;
    end
    clear pixelIntensity
end
for k = 1:length(Stats)
    S = Stats{k};
    exp.thresh = th(k);
    for sname = ["activity"]
        close all
        statname = char(sname);
        groupedstatistics = gatherGroupStatistics(S, grabstatid(statname), exp, project);
        saveGroupedStats(groupedstatistics, project, char(sname), extradirname,exp)
        plotgroupedstatistics(groupedstatistics, statname, exp, project,'',extradirname);
    end
    
end


%playMovie(allREMframes);


% 
% 
%  for iexp = 1:length(project.experiments)
%     if ~project.checkedExperiments(iexp); continue; end
%      
%      [num2str(iexp) ' out of ' num2str(length(project.experiments))]
% 
%  
%     folder = [project.folder project.experiments{iexp} '/data/'];
%     videolocationfile = [folder 'videolocation_' project.experiments{iexp} '.txt'];
% 
%     videolocation = getVideoLocation(videolocationfile);
%     
%     [pixelIntensity, pixelValue, validpixels] = getPixelIntensities(videolocation, numframes(iexp));
%     [p_ratio, freqrez, tt] = doFourierREMAnalysis(pixelIntensity, FR, timerez, numframes(iexp), folder, true);
% 
%     p_ratio = getREMRatioFile(folder, timerez, freqrez, numframes(iexp));
%     
%     REMmovie(p_ratio, siz, pthresh, pixelValue, validpixels, 0, true, [folder project.experiments{iexp}], timerez, freqrez)
%     numpixels = size(p_ratio,1);
%     numactivesites =  getNumREMSites(pthresh, p_ratio, siz)/numpixels;
%     
%     REMintervals = getREMintervals(numactivesites, REMspatialthreshold , numframes(iexp), timerez, REMdurationthreshold, tt);
%     plotREMintervals(REMintervals, numactivesites, timerez, numframes(iexp), pthresh, tt)
%     
%     figsavename = [project.folder project.experiments{iexp} '/figures/'];
%     ['saving fig to ... ' figsavename]
%     figsavename = [figsavename 'fracREMpix_pthresh_' num2str(pthresh) ];
%     figsavename = [figsavename '_REMspaceth_' num2str(REMspatialthreshold)];
%     figsavename = [figsavename '_REMdtimeth_' num2str(REMdurationthreshold)];
%     saveas(gcf,[figsavename '.png' ])
%     close all
%     
%     REMintervalfilename = [folder 'REMintervals_pthresh_' num2str(pthresh) '_REMspaceth_' num2str(REMspatialthreshold) '_REMdtimeth_' num2str(REMdurationthreshold) '_Trez_' num2str(timerez) '.mat'];
%     
%     save(char(REMintervalfilename), 'REMintervals' )
%     
%     REMdurationfrac(iexp) = length([REMintervals{2,:}])/length(numactivesites);
%  end
%clear validpixels










%%%%%%%%%%%%%%%%%%%FUNCTIONS


function plotREMintervals(REMintervals, numactivesites, timerez, numframes, pthresh, tt )

    times = tt;
    plot(times, numactivesites)
    hold on

    for i=1:size(REMintervals,2)
      plot(REMintervals{2,i},REMintervals{1,i}, 'color','r')
      hold on
    end
    
    ylabel('# of pixels in REM/ # of pixels')
    xlabel('time (s)')
    xt = get(gca, 'XTick');                                 % 'XTick' Values
    set(gca, 'XTick', xt, 'XTickLabel', xt*timerez) %relabel axis to be in seconds
    set(gca,'fontsize', 14)
    
    figtitle = 'fraction of pixels in REM with p-thresh = ';
    figtitle = [figtitle num2str(pthresh)];
    
    
    title(figtitle)



end


function REMratio = getREMRatioFile(folder, timerez, freqrez, NumFrames)
    filename = ['p_ratio_timerez=' num2str(timerez) 's_freqrez=' num2str(freqrez) 'Hz_NumFrames=' num2str(NumFrames) '.txt' ];
    REMratio = importdata([folder filename]);
 end

function videolocation = getVideoLocation(videolocationfile)

fileID = fopen(videolocationfile);
videolocation = fscanf(fileID, '%c');
fclose(fileID); 

end

 
 function numactivesites =  getNumREMSites(pthresh, pratio, siz)

 pratio(pratio >= pthresh) = 0;
 
 for i=1:size(pratio,2)
    array = zeros(siz);
    idx = find(pratio(:,i) ~= 0);
    numactivesites(i) = length(idx);
 end
 end
 
 
 
 
 
 