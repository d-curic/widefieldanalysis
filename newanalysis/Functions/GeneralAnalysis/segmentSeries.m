
function [section, times] = segmentSeries(A)
ne0 = find(A~=0);                                   % Nonzero Elements
ix0 = unique([ne0(1) ne0(diff([0 ne0])>1)]);        % Segment Start Indices
ix1 = ne0([find(diff([0 ne0])>1)-1 length(ne0)]);   % Segment End Indices
for k1 = 1:length(ix0)
    section{k1} = A(ix0(k1):ix1(k1));
    times{k1} = ix0(k1):ix1(k1);
end
end