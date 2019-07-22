%close all
%clear all
pwd
addpath(genpath([pwd '/Functions']))
project = setupProject('maindir.txt');

%%
 exp.FR = 150;
 filtparams = [5 6];
 exp.filtparams = filtparams;
 exp.filterorder = 400;
 exp.band = 'BP';
 exp.randomizepixID = false;
 exp.callframes = [1000 4001];

 exp.tag = '';


 project.checkedExperiments = ones(1,length(project.experiments));

 exp = checkifCoefficientsExist(exp, project);
 
 
%%
for iexp = 7:length(project.experiments)
    
        
   	[pixelIntensity, exp]  = pixelIntensitiesPipeline(project, exp, iexp);
    
    exp = getMask(exp,'');
    
    %[maskedIntensity, exp] = applyMask(pixelIntensity,exp);
    %clear pixelIntensity
    
    [FTx(iexp,:),f] = getFourierSpectra(pixelIntensity,exp, project);
    close all
    
    
    %flocation = [project.folder 'filteredData/' 'from' num2str(filtparams(1)) 'to' num2str(filtparams(2)) 'Hz_samplerate' num2str(exp.FR) '/'];
    %fname = [flocation project.experiments{iexp} '_Filt_' num2str(filtparams(1)) '_' num2str(filtparams(2)) 'Hz' exp.tag];
    %X = filterRecording(pixelIntensity,exp);
    
    %options.overwrite = true;
    %options.message = false;
    %CropandSaveTiff(X, fname, options);
    %clear X
    
end
%%

[uLabels, pLabels] = getUniqueLabels(project)

for i = 1:size(FTx,1)
    if ~isempty(strfind(project.labels{i}, 'alive'))
        figure(1)
        figtitle = 'power spectrum, alive';
    else
        figure(2)
        figtitle = 'power spectrum, dead';
    end
plot(f,log(FTx(i,:)), 'DisplayName', [project.labels{i}])
legend()
ylim([-1.5,1])
xlim([min(f) max(f)])
title(figtitle)
set(gca, 'FontSize', 14)
hold on
xlabel('f (Hz)')
ylabel('log(|P(f)|)')
end


%%
% close all
% for i = 1:1300
%  imagesc(X(:,:,i))
%  caxis([-.25,.25])
%  drawnow
% end

function [mFTx, f] = getFourierSpectra(data, exp, project)
    
L = exp.numframes;
Fs = exp.FR;

validpixels = find(exp.mask ~= 0);

for i=1:length(validpixels)
    Y = fft(data(validpixels(i),:));
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);

    f = Fs*(0:(L/2))/L;
    FTx(i,:) = P1;
end

plot(f,log(mean(FTx)))
ylim([-1.5,1])
xlim([min(f) max(f)])
title(['Mean Amplitude Spectrum of ' project.labels{1}])
xlabel('f (Hz)')
ylabel('log(|P1(f)|)')


foldername = exp.expResultsFolder;
checkifDirExists(foldername)

saveas(gcf, [foldername 'Spectrum' project.labels{1} '.png'])

mFTx = mean(FTx);

end

function [maskedpixelIntensity, exp] = applyMask(pixelint, exp)
    
    invalidpixidx = find(exp.mask == 0);
    maskedpixelIntensity = pixelint;
    maskedpixelIntensity(invalidpixidx) = 0;
end