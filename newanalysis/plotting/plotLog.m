function plotLog(S, nbins, plotoptions)
    
    if max(S) == min(S);
        return
    end


    
    if ~isfield(plotoptions, 'showlegend')
        plotoptions.showlegend = false;
    end
    if ~isfield(plotoptions, 'linestyle')
        plotoptions.linestyle = '';
    end    
        if ~isfield(plotoptions, 'cdf')
        plotoptions.cdf = false;
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
    if ~isfield(plotoptions, 'ylabel')
        if isfield(plotoptions, 'xlabel')
        plotoptions.ylabel = ['p(' plotoptions.xlabel ')' ];
        else
        plotoptions.ylabel = '';
        end
    end
    
    if ~isfield(plotoptions, 'xlabel')
        plotoptions.xlabel = '';
       end

       if ~isfield(plotoptions, 'title')
        plotoptions.title = '';
       end
         if ~isfield(plotoptions, 'markerstyle')
        plotoptions.markerstyle = '';
       end
    
    
    
    linespec = [plotoptions.linestyle plotoptions.color plotoptions.markerstyle]; 
    
    if plotoptions.cdf
    n = length(S); 
    S = reshape(S, numel(S), 1); %make sure S is a columnvector.
    c = [sort(S) (n:-1:1)'./n];
    plot(c(:,1), c(:,2).*c(:,1).^(plotoptions.scale-1), linespec, 'DisplayName',plotoptions.displayname);
    else
            p = logpdf(S,nbins);
    
    if isempty(p)
        return
    end
        
        plot(p(:,1),p(:,2).*p(:,1).^(plotoptions.scale), linespec, 'DisplayName',plotoptions.displayname);
    end    
    
    set(gca,'xscale','log','yscale','log', 'fontsize',14);
    xlabel(plotoptions.xlabel);
    ylabel(plotoptions.ylabel);
    title(plotoptions.title);
    
    if plotoptions.showlegend
    legend()
    end
    
    
end
