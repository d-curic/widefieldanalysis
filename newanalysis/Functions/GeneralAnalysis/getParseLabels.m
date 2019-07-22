function parsedlabels = getParseLabels(labels)

parsedlabels = {};
k = 1;
for i = 1:length(labels)
    
    substrings = strsplit(labels{i}, ',')
    for j = 1:length(substrings)
       
            if ~any(strcmp(parsedlabels,substrings{j}));
                parsedlabels{k} = substrings{j};
                k = k+1;
            else
                continue
            end
        
        
    end
    
end


end