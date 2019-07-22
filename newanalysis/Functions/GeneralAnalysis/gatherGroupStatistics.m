

function statsandlabels =  gatherGroupStatistics(stats, statid, exp, project)
    %PURPOSE: This code is a little complicated... it takes in statistics and groups them. For example,
    %lets say you have 4 trials, the first two being ctrl and the last 2
    %being models.
    %We have 4 individual statistics, but what we would like is 2, one for
    %each group. This code does that, but in the more general case of
    %multiple labels.
    
    %INPUT:
        %Stats -- a cell array. Stats{i} is the trial. Stats{i}{2} is are
        %the calculated statistics of the i-th trial (stats{i}{1} just has string labels). 
        %Stats{i}{2}{statid} is the statistic you are interested in.
        
        %statid -- the id of the thing you are interested in
        
        %exp -- experimental parameters. Should contain the groups, of
        %which there are two. 
            %exp.allGroups -- contains the groups and is split into two
            %sections. For example, lets say you have 4 trials, the first two being ctrl and the last 2
            %being models. Then, exp.allGroups = {{'ctrl', 'model'}, [1 1 2 2]; ... other groups here}
            %exp.chosenGroups -- if you have more than one grouping, like
            %lets say they are filtered differently, then you can chose
            %them individiually. Or, for example, lets say you also want to
            %distinguish between trials within a group. Then you could have
            %exp.allGroups = {{'ctrl', 'model'}, [1 1 2 2]; {'1', '2', '3', '4'}, [1 2 3 4]}
            %now you can set exp.chosengroups = [1 1], [1 0], [0 1],
            %depending on if you want to include that categorization or
            %not. 
        
        %project -- the project
    
    
    %OUTPUT:
    
        %statsandlabels -- (snl for short here) a 2x1 cell. snl{1} contains
        %the grouped statistics. snl{2} contains the labels corresponding
        %to the that statistic. 


    %first we find all the unique group lebels that exist
    for iexp = 1:length(project.experiments)
        indivlabel = [];
        %go through each selected group, and make a label for the
        %experiment based on which groups it belongs to
        for i = find(exp.chosenGroups == 1)
            indivlabel(i) = exp.allGroups{i,2}(iexp);
        end
        labels{iexp} = num2str(indivlabel);
    end 
    uniquelabels = unique(labels);
    
    statistics = cell(1, length(uniquelabels));
    labelname = cell(1, length(uniquelabels));
    
    %for every unique label
    for i = 1:length(uniquelabels)
       %find the elements that correspond to those labels, and their indicies 
       
       finduniquelabel = strfind(labels, uniquelabels{i});
       uniquelabelidx = find(~cellfun(@isempty,finduniquelabel));
       %itterate through every memeber of that group and collect the
       %corresponding statistic
       for j = uniquelabelidx
           
           statistics{i} = [statistics{i}, stats{j}{2}{statid}];
           
           %now we want to build the label name
           labelstatname = '';
           ll = str2num(uniquelabels{i});
           for k = find(ll > 0)
                labelstatname = [labelstatname exp.allGroups{k}{ll(k)} ' '];
           end
           labelname{i} = labelstatname;
       end
               
    end
    
    statsandlabels = {statistics; labelname};
    
end
