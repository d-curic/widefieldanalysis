function plotLog(S, nbins, plotoptions)
    
    if max(S) == min(S);
        return
    end

    p = logpdf(S,30);
    
    if isempty(p)
        return
    end
    
    if ~isfield(plotoptions, 'showlegend')
        plotoptions.showlegend = false;
    end
    if ~isfield(plotoptions, 'linestyle')
        plotoptions.linestyle = '';
    end    
    if ~isfield(plotoptions, 'color')
        plotoptions.color = '';
    end
    if ~isfield(plotoptions, 'scale')
        plotoptions.scale = 0;
    end
    if ~isfield(plotoptions, 'displayname')
        plotoptions.displayname = '';
    end
       if ~isfield(plotoptions, 'xlabel')
        plotoptions.xlabel = '';
       end
       if ~isfield(plotoptions, 'ylabel')
        plotoptions.ylabel = '';
       end
       if ~isfield(plotoptions, 'title')
        plotoptions.title = '';
       end
         if ~isfield(plotoptions, 'markerstyle')
        plotoptions.markerstyle = '';
       end
    
    
    
    linespec = [plotoptions.linestyle plotoptions.color plotoptions.markerstyle]; 
        
    plot(p(:,1),p(:,2).*p(:,1).^(plotoptions.scale), linespec, 'DisplayName',plotoptions.displayname);
        
    set(gca,'xscale','log','yscale','log', 'fontsize',14);
    xlabel(plotoptions.xlabel);
    ylabel(plotoptions.ylabel);
    title(plotoptions.title);
    
    if plotoptions.showlegend
    legend()
    end
    
    
end