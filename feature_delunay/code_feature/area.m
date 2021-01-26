function s=tringl(a,b,c)
s=[];
s = (a+b+c)/2;
ara = sqrt(s.*(s-a).*(s-b).*(s-c));
end