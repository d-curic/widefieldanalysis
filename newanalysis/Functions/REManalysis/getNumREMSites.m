 function numactivesites =  getNumREMSites(pthresh, pratio, siz)

 pratio(pratio >= pthresh) = 0;
 
 for i=1:size(pratio,2)
    array = zeros(siz);
    idx = find(pratio(:,i) ~= 0);
    numactivesites(i) = length(idx);
 end
 end