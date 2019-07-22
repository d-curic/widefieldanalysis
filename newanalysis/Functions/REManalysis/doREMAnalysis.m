
function [p_ratio, exp] = doFourierREMAnalysis(pixelIntensity,exp)% FR, timerez,numframes, folder, savedata)

'Performing REM analysis...'

FR = exp.FR;
timerez = exp.timerez;
numframes = exp.numframes;


for ii=1:size(pixelIntensity,1)
Trace = pixelIntensity(ii,:);
times = (1:1:length(Trace))*1/FR/60;
exp.freqrez = sqrt(2*pi)/timerez;



[pp, ff, tt] = pspectrum(Trace, FR, 'spectrogram', 'FrequencyLimits', exp.freqlim,'FrequencyResolution',exp.freqrez, 'OverlapPercent', 0);
%pspectrum(Trace, FR, 'spectrogram', 'FrequencyLimits', [0.5 6],'FrequencyResolution',0.8, 'OverlapPercent', 0)
exp.tt = tt;

switch exp.method
    case 'bandpass'
        
%values from Cortical layer 1 and layer 2/3 astrocytes exhibit distinct calcium dynamics in vivo.
 %2008 Jun 25;3(6):e2525. doi: 10.1371/journal.pone.0002525.
 %find interval for the synchronized states
 [sy_minval, sy_minidx] = min(abs(ff-0.5));
 [sy_maxval, sy_maxidx] = min(abs(ff- 2));
 
 %find interval for the desynchronized states
 [de_minval, de_minidx] = min(abs(ff-3));
 [de_maxval, de_maxidx] = min(abs(ff- 4));

 sy_power = sum(pp(sy_minidx:sy_maxidx,:),1);
 de_power = sum(pp(de_minidx:de_maxidx,:),1);
% 
 
 p_ratio(ii,:) = sy_power./de_power;
 
    case 'highpass'
      
  p_ratio(ii,:) = sum(pp(3:exp.freqlim(2),:),1);
end 

end

if exp.savePowerRatioData;
savefilename = ['p_ratio_timerez=' num2str(timerez) 's_freqrez=' num2str(exp.freqrez) 'Hz_NumFrames=' num2str(numframes) '.txt' ];
 ['saved as ... ' exp.expDataFolder savefilename]
 dlmwrite([exp.expDataFolder savefilename],p_ratio)
else
    'WARNING: NOT SAVING DATA!!!!!!!!!!!!!!!'
end
 
end
