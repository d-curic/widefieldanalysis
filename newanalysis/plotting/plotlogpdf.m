
function h = plotlogpdf(X, nbins, plotoptions)
p = logpdf(X,nbins);

h = plot(p(:,1),p(:,2), 'DisplayName', plotoptions.displayname)
set(gca,'xscale','log','yscale','log')
legend()
end