function ara=leng(a1,b1,c1)
a= pdist2(a1,b1);
b= pdist2(b1,c1);
c= pdist2(a1,c1);
ara=[a,b,c];
end