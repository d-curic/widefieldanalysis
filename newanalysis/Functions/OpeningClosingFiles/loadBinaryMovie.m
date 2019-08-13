function [frames, msg, listing] = loadBinaryMovie(project, exp)
    %
    %
    %

    moviedir = [project.folder exp.name '/data/'];
        
    listing = dir([moviedir  '*Fqrez=' num2str(exp.freqrez) '*thresh=' num2str(exp.thresh) '*' exp.tag '*.tif'] );
    msg = '';
    if length(listing) == 0
        msg = 'found no movie'
        frames = [];
        return
    elseif length(listing) > 1
        msg = 'found multiple movies'
        frames = [];
        return
    end
    [listing.folder '/'   listing.name]
    frames = loadtiff([listing.folder '/'   listing.name]);

end
