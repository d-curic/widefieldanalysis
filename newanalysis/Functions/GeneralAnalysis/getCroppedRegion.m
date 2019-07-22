
function exp = getCroppedRegion(exp)

 array = zeros(exp.siz);
 array(exp.validPixelIdx) = 1;
 
 A = array;
 
 Ax = sum(A, 2);
 Ay = sum(A, 1);
 
 Ax(Ax > 0) = 1;
 Ay(Ay > 0) = 1;
 
 xvalid = find(Ax == 1);
 yvalid = find(Ay == 1);
 
 xmin = min(xvalid);
 xmax = max(xvalid);
 ymin = min(yvalid);
 ymax = max(yvalid);

newregion = A(xmin:xmax, ymin:ymax);
%newregion(newregion > 0 ) = 1;

exp.newregion = newregion;

end
