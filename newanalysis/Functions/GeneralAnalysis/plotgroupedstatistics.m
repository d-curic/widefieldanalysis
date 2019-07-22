
function plotgroupedstatistics(groupedstats, statname, exp, project, extrafigname, extradirname)
nbins = 30;

% 
h=figure;
set(h,'visible','off');
%set(h,'visible','on');

for i=1:length(groupedstats{1})
    if isempty(groupedstats{1}{i}); continue; end
    if max(groupedstats{1}{i})==min(groupedstats{1}{i}); continue; end
    p = logpdf(groupedstats{1}{i},nbins);
    numevents = length(groupedstats{1}{i});
    for j=1:length(exp.postselectGroups)
        if ~isempty(strfind(groupedstats{2}{i},exp.postselectGroups{j}));
               
    plot(p(:,1),p(:,2), 'DisplayName', [groupedstats{2}{i} num2str(numevents)])
    hold on
        end
    end
end

set(gca, 'xscale','log','yscale','log', 'fontsize',14)
title([statname ' distribution'])
legend()




    figurename = [statname  '_dis'];
    figurename = [figurename '_Thrstyle=' exp.threshstyle ];
    figurename = [figurename '_thr=' num2str(exp.thresh)];
    figurename = [figurename cell2mat(exp.postselectGroups)];
    figurename = [figurename extrafigname];

    
    figuredir = [project.folder 'results/ClusterAnalysis/' extradirname exp.threshstyle '/']; 
    figuredir = [figuredir cell2mat(exp.postselectGroups) '/' statname '/'];
    
    
    
    if ~exist(figuredir, 'dir');
        mkdir(figuredir);
    end

    ['saving to ...' figuredir]
    ['saving as ...' figurename]
    
saveas(gcf, [figuredir figurename '.png'])
% 
set(h,'visible','on');
delete(get(h,'children'));


end

