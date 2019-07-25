function project = setupProject(maindirfile)

addpath(genpath('/media/dcuric/400CCB3D50C6D071/netcalJan2019'))

fileID = fopen(maindirfile);
C = textscan(fileID, '%q');


if contains(C{1}{1}, 'Seagate')
    maindir = [C{1}{1} ' ' C{1}{2} ' ' C{1}{3} ' ' C{1}{4}]
    projectdirectory =[maindir C{1}{5}];
    projectname =C{1}{6};
else
    maindir = C{1}{1};
    projectdirectory =[maindir C{1}{2}];
    projectname =C{1}{3};
end

% projectdirectory =[maindir C{1}{2}];
% projectname =C{1}{3};
fclose(fileID);

checkifDirExists(strcat(projectdirectory,'results'))

project = loadProject('folder',projectdirectory,'name',char(projectname));




end