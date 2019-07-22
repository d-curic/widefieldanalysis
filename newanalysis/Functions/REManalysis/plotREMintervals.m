
function plotREMintervals(REMintervals, numREMpixels, timerez, pthresh, tt )
    %PURPOSE
        %plots the number of pixels in the REM state and highlights which intervals were chosen for a whole brain REM state
    %INPUT
        % REMintervals: the intervals over which the brain was determined
        % to be in REM state
        % numREMpixels: The number of REM active pixels in the brain. The brain is in the
        % REM state if over pthresh of the pixels are in REM state
        % timerez: time resolution
        % pthresh: see numREMpixels
        % tt : an array of time steps with time resolution trez.
        
    times = tt;
    plot(times, numREMpixels)
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
