
function videolocation = getVideoLocation(project, iexp)

%search for the videolocation file in the /data/ folder and return the
%location of the video.

checkVideoLocationFiles(project, project.experiments{iexp}); %first check that the file actually exists

folder = [project.folder project.experiments{iexp} '/data/'];
videolocationfile = [folder 'videolocation_' project.experiments{iexp} '.txt'];
fileID = fopen(videolocationfile);
videolocation = fscanf(fileID, '%c');



if strfind(videolocation, '/davor/')
   ['Changing videolocation substring from /davor/ to /dcuric/ in getVideoLocation.m']
    videolocation = strrep(videolocation, '/davor/', '/dcuric/') ;
end
     

fclose(fileID); 

end
