function statid = grabstatid(name)
%'Activity' 'Size' 'starttime' 'endtime' 'duration' 'didnottouch'
switch name
    case 'activity'
        statid = 1;
    case "size"
        statid = 2;
    case "starttime"
        statid = 3;
    case "endtime"
        statid = 4;
    case "duration"
        statid = 5;
    case 'didnottouch'
        statid = 6;
    otherwise
        'this is not a valid statistic number; please choose one of the following'
        'activity' 
        'size' 
        'starttime' 
        'endtime' 
        'duration' 
        'didnottouch'
end
end