
function stat = loadStats(th, project, exp)
       statlocationdir = [project.folder 'results/rawStats/' exp.threshstyle '/'];
       filename = ['Stats_th=' num2str(th)];
       s = load([statlocationdir filename '.mat']);
       stat = s.stattosave;
end
