
function exp = getMask(exp, varargin)
    filelocation = exp.videolocation;
    dirdelim = strfind(filelocation, '/');
    dir = filelocation(1:dirdelim(end));
    
    if isempty(varargin) && ~strcmp(varargin{1},'')
    filename = [dir varargin{1}];
    else
    filename = [dir 'MouseMask.tif'];
    end
    
    exp.mask = imread(filename);
end