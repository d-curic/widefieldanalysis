close all
clear all
pwd
addpath(genpath([pwd '/Functions']))
project = setupProject('maindir_5to6.txt');

resultdir = [project.folder 'results/PhaseSynch/'];

      if ~exist(resultdir, 'dir');
        mkdir(resultdir);
    end

%%

%when running a new pipeline, this is the main thing you want to change

 exp.FR = project.defaultFPSoptionsCurrent.frameRate;
 exp.timerez = 2.5;
 exp.thresh = 0;
 exp.callframes = [1000 4500];
 exp.threshstyle = 'pixelbypixel';
 exp.randomizepixID = false;

 project.checkedExperiments = ones(1,length(project.experiments));
%% 
calcphasediff = false;
jet_wrap = vertcat(jet,flipud(jet));

for iexp = 1:length(project.experiments)
	close all
    if ~project.checkedExperiments(iexp); continue; end

	[pixelIntensity, exp]  = pixelIntensitiesPipeline(project, exp, iexp);
    
    
    'taking Hilbert Transform....'
    H = hilbert(pixelIntensity);
    reH = real(H);
    imH = imag(H);
    
    phase = mod(atan2(imH,reH),0);
    
    'making histograms ... '
    for i =1:exp.numframes
       h = histogram(phase(:,i), 'Normalization','probability','BinEdges',-pi:0.01*pi:pi);
       phasehist(i,:) = h.Values;
       
       if calcphasediff
       randsites = randperm(size(H,1), 60);
       
       for j = 1:length(randsites)%size(H,1)
          for k = j:length(randsites)%size(H,1)
              if j == k; continue; end
              phasediff(j,k,i) = phase(randsites(j),i) - phase(randsites(k),i); 
          end
       end
       
       h2 = histogram(reshape(phasediff(:,:,i), [1 prod(size(phasediff,1)*size(phasediff,2))]), 'Normalization','probability','BinEdges',-2:0.05:2);
       phasediffhist(i,:) = h2.Values;
       
       end
       
       
       
    end
    %%
    
    figure(1)
    imagesc(phasehist')
    yticks(1:49:size(phasehist,2))
    yticklabels({'-\pi','-\pi/2','0','\pi/2','\pi'})
    
    %figure(2)
    %plot3(reH,imH,1:exp.callframes)
    
    
    if calcphasediff
        numfigs =  findobj('type','figure');
    n = length(numfigs);
    figure(n+1)
    imagesc(log(phasediffhist'))
    ax = gca;
    
    ax.YTickLabel = sprintfc('%d',ax.YTick - max(ax.YTick)/2-1)
    end
    
    %%
for i = 1:exp.numframes
    entr(i) = entropy(phasehist(i,:))/log(length(phasehist(i,:)));   
end
plot(entr)
histogram(entr,30, 'Normalization','probability')
xlabel('Relative Entropy')
ylabel('Probability')

saveas(gcf, [resultdir 'EntropyHist' num2str(iexp) '.png'])
saveas(gcf, [project.folder project.experiments{iexp} '/Results/' 'SynchEntropyHist.png'])


expentr{iexp} = entr;
    
end

%%

for i = [1:10]
    if isempty(expentr{i}); continue; end
    histogram(expentr{i}+i/3,30, 'Normalization','probability','DisplayName',num2str(i))
    hold on
    legend()
end


%%




 

