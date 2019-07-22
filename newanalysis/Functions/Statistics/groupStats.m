
function  groupedStats = groupStats(Stats, sname, parsedlabels, project)
    statid = grabstatid(sname)
groupedStats = cell(1,length(parsedlabels));
for i = 1:length(parsedlabels)
    labelpos = strfind(project.labels, parsedlabels{i});
    
    for iexp = 1:length(project.experiments)
        if isempty(labelpos{iexp}); continue; end
        groupedStats{i} = [groupedStats{i} Stats{1}{iexp}{2}{statid}]
        
    end
    
end
end

