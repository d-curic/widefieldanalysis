
function subsetout = getREMintervals(numREMsites, numREMsites_thresh, REMduration_thresh, tt, filenameparams)
    %PURPOSE: 
        %Requires doFourierREManalysis to have been ran
        %finds regions of whole brain REM
        %whole brain REM is defined when numREMsites_thresh number of REM state
        %pixels occur for REMduration_thresh duration of time
    %INPUT:
        %numREMsites: the number of pixels in the REM state
        %numREMsites_thresh: candidate Whole brain rem intervals are
        %considered only if they contain this fraction of REM pixels
        %REMduration_thresh: candiate whole brain rem intervals are
        %considered only if they last this long
        %tt: a vector of times over which pixel rems were calculated
        % filenameparams: cell array 1: the folder where it will be saved,
        % 2: the threshold used for pixel REM and 3: time resolution of tt.
    %OUTPUT:
        % creates a file with the whole brain REM state intervals. 
    
    
    folder = filenameparams{1};
    pthresh = filenameparams{2};
    trez = filenameparams{3};

temp = numREMsites;
temp(temp <=  numREMsites_thresh) = 0;


temp2 = temp + numREMsites;
k = 1;
sub = [];
tsub = [];
for i=1:length(temp2)
    if temp2(i) ~= numREMsites(i);
       subset{1,k} = sub;
       subset{2,k} = tsub;
        k = k+1;
       sub = [];
       tsub = [];
       continue;
    end
    sub = [sub, numREMsites(i)];
    tsub = [tsub, tt(i)];
end

k = 1;
subsetout{1,k} = [];
subsetout{2,k} = [];
for i = 1:size(subset,2)
   if length(subset{2,i}) > REMduration_thresh;
       subsetout{1,k} = subset{1,i};
       subsetout{2,k} = subset{2,i};
       k = k+1;
   end
end



REMintervalfilename = [folder 'REMintervals_pthresh_' num2str(pthresh) '_REMspaceth_' num2str( numREMsites_thresh) '_REMdtimeth_' num2str(REMduration_thresh) '_Trez_' num2str(timerez) '.mat'];
save(char(REMintervalfilename), 'subsetout' )

end
