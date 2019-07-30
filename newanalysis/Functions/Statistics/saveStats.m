
function saveStats(stats, th, project)
       savedir = [project.folder 'results/rawStats/'];
       checkifDirExists(savedir);
       'Saving stats ... '
for i=1:length(th)
       filename = ['Stats_th=' num2str(th(i))];
       stattosave = stats{i};
       save([savedir filename '.mat'],  'stattosave') 
       clear stattosave
    end

end
