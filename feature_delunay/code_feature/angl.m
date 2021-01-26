function ara=angl(a1,b1,c1)
a=getAngle(a1,b1); 
b=getAngle(b1,c1);
c=getAngle(a1,c1); 
ara=[a,b,c];
end