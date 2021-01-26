function ara=tringl(a1,b1,c1)
a= pdist2(a1,b1);
b= pdist2(b1,c1);
c= pdist2(a1,c1);

s = (a+b+c)/2;

ara = sqrt(s.*(s-a).*(s-b).*(s-c));

end