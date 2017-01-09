 function normalized = normalizeTime(array,minarr,maxarr)

     %Normalize to [0, 1]:
     array = (array - minarr) / (maxarr - minarr);

     % Then scale to [2500,500]:
     range2 = 2500 + 500;
     normalized = (array*range2) - 500;
 end