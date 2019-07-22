function REMratio = getREMRatioFile(folder, timerez, freqrez, NumFrames)
    filename = ['p_ratio_timerez=' num2str(timerez) 's_freqrez=' num2str(freqrez) 'Hz_NumFrames=' num2str(NumFrames) '.txt' ];
    REMratio = importdata([folder filename]);
 end