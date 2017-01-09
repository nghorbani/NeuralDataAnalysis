function r = sampleHist(p,n)

r = rand(1,n);
cp = cumsum(p);
for i=1:n
    r(i) = find(r(i)<cp,1,'first');
end

