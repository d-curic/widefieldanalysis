function [uniquelabels, parsedlabels] = getUniqueLabels(project)
uniquelabels = {};
k = 1;
for i = 1:length(project.labels)
    
    if ~any(strcmp(uniquelabels,project.labels{i}))
    uniquelabels{k} = project.labels{i};
    k = k+1;
    else
     continue
    end
    
end

parsedlabels = getParseLabels(uniquelabels);

end


