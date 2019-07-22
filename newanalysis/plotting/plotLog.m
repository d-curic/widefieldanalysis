function plotLog(S, nbins, plotoptions)
    
    p = logpdf(S,30);
    
    if isempty(p)
        return
    end
    
    linespec = [plotoptions.linestyle plotoptions.color]; 
        
    plot(p(:,1),p(:,2).*p(:,1).^(plotoptions.scale), linespec, 'DisplayName',plotoptions.displayname)
    
        
    set(gca,'xscale','log','yscale','log', 'fontsize',14);
    xlabel(plotoptions.xlabel);
    ylabel(plotoptions.ylabel);
    title(plotoptions.title);
    legend()
    
    
end