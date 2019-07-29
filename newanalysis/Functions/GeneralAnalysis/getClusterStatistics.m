
function [Statistics, CC] = getClusterStatistics(CC, exp)
    %PURPOSE: gather various statistics from clustering, such as size
    %duration, activity etc.
    
    %INPUT: a cluster structure created from the matlab command bwconncomp
    %and experiment parameters stored in exp. 
    
    %OUTPUT: Outputs an array with the following statistics in the
    %following order
    %Activity' 'Size' 'starttime' 'endtime' 'duration' 'didnottouch'
    %Activity -- if a pixel is on, then turns off, then turns back on, it
                %contributes twice 
    %Size -- if a pixel is on, then turns off, then turns back on, it
                %contributes only once
    %starttime- time stamp of start of cluster
    %endtime- time stamp of end of cluster
    %duration - endtime - starttime (kind of redundant but whatever)
    %didnottouch - 0 if the cluster touched the region outside the FOV, 1
                %if it did not
                
    %we save 3 files: one for activty, one for size and one for
    %didnottouch. Files are saved in [exp.expDataFolder 'Statistics/' exp.threshstyle '/']
    

'Gathering cluster statistics ... '


%this is the set of pixels that constitute our field of view
validregion = exp.newregion;

%now we set up the exluded region in the image
excludedRegion = abs(validregion - 1);
excludedRegion(1,:) = 1;
excludedRegion(end,:) = 1;
excludedRegion(:,1) = 1;
excludedRegion(:,end) = 1;
excludedRegion = imdilate(excludedRegion,[0 1 0; 1 1 1; 0 1 0]);
excludedPixelsIdx = find(excludedRegion == 1);

siz = size(validregion);
siz(3) = exp.numframes;
validpixels = find(validregion == 1);


DidnotTouch_Activity= [];
DidnotTouch_Size= [];

didnottouch = zeros(1,length(CC.PixelIdxList));
Activity_stat = [];
Size_stat = [];
eventstart = [];
eventend = [];
eventduration = [];
%didnottouch = [];
for i=1:length(CC.PixelIdxList)
   Activity_stat(i) =  size(CC.PixelIdxList{i},1);
   [ii jj kk] = ind2sub(siz,CC.PixelIdxList{i});
   
   CC.PixelSubIdxList{i} = [ii jj];
   CC.PixelEventFrameList{i} = [kk];
   eventstart(i) = kk(1);
   eventend(i) = kk(end);
   eventduration(i) = length(unique(kk));
   
   un = unique(mod(CC.PixelIdxList{i}, siz(1)*siz(2)));
   Size_stat(i) =  size(un,1);
   clear ii jj
   if isempty(intersect(un, excludedPixelsIdx)) 
          didnottouch(i) = 1;
    end
    clear un
end

Activity_stat(Activity_stat==0) = [];
Size_stat(Size_stat==0) = [];

Statistics{1,:} = {'Activity', 'Size', 'starttime', 'endtime', 'duration', 'didnottouch'};
Statistics{2,:} = {Activity_stat, Size_stat, eventstart, eventend, eventduration, didnottouch};




filenameparameters = ['_thresh=' num2str(exp.thresh) '_threshstyle_' exp.threshstyle];
foldername = [exp.expResultsFolder 'Statistics/' exp.threshstyle '/'];

['Saving stats to ... ' foldername]

 if ~exist(foldername, 'dir');
         mkdir(foldername);
 end

dlmwrite([foldername 'SizeStat' filenameparameters],Size_stat);
dlmwrite([foldername 'ActivityStat' filenameparameters],Activity_stat);
dlmwrite([foldername 'didnottouch' filenameparameters],didnottouch);


end