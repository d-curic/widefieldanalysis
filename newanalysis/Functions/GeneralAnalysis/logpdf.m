function p = logpdf(x, nbins)
%PURPOSE: returns the probability distibution with logarithmic binning
%INPUT: %x = data
        %nbins = number of total bins
%OUTPUT:%pdf = logarithmically binned probability distribution
             %first column is xvalues
             %second column is yvalues

xmax = max(x);
xmin = min(x);

s = xmin;
i=1;
n = length(x);

%This part is just setting up the log bins
logbinwidth = (log10(xmax) - log10(xmin))/nbins;
S = [];
p =[];
if xmin == xmax
   return; 
end

while s<=xmax
    S(i) = (s);
    i = i+1;
    s=s*power(10.,logbinwidth);
end %while
S = unique(S);

j=0;

for i=1:length(S)-1
    
    a = find(x>=S(i) & x<S(i+1)); %find all the values in x in this range
    
    if (length(a) == 0)
        continue
    end;
    j = j+1; 
    b = x(a);
    p(j,1) = mean(b); %sets the center of the bin
    %pdf(j,2) = length(a)/(n*(floor(S(i+1)) - floor(S(i))));
    p(j,2) = length(a)/(n*(S(i+1) - S(i))); 
    
%     if scaled
%         p(j,1) = p(j,1).*p(j,1).^(-alpha);
%         p(j,2) = p(j,2).*p(j,1).^(-alpha);
%     end
    
end %for

end %function