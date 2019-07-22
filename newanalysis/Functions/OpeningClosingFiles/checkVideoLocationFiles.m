function checkVideoLocationFiles(project, name)
  %check to see if certain files exist that are necessary to proceed.   
  
  ['checking ' project.folder name '/data/videolocation_' name '.txt']
  if ~exist([project.folder name '/data/videolocation_' name '.txt'])
      'location file does not exist, generating'
      genExpVideoLocationFile(project, name);
  else
      'found'
  end

end