
function  groupedStats = groupStats(Stats, sname, parsedlabels, project,exp)
    statid = grabstatid(sname)
groupedStats = cell(1,length(parsedlabels));
for i = 1:length(parsedlabels)
    labelpos = strfind(project.labels, parsedlabels{i});
     for iexp = 1:2:length(project.experiments)
        if isempty(labelpos{iexp}); continue; end
        clear Events
        Events = Stats{1}{iexp}{2}{statid};
        if exp.removeborderEvents
            touched = Stats{1}{iexp}{2}{6};
            touched = double(~touched);
            Events = Events.*touched;
            Events(Events ==0) = [];
        end
        groupedStats{i} = [groupedStats{i} Events];
        
    end
    
end
end

