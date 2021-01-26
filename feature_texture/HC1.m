function histo=HC1(res)
res=res(:,:,1);
p=double(res);
[m,n]=size(res);
histo=zeros(1,256);
for i=1:m-3
    for j=1:n-3
        b(1)=p(i+3,j)>=p(i+3,j+1); b(2)=p(i+3,j+1)>=p(i+2,j+1);
        b(3)=p(i+2,j+1)>=p(i+2,j); b(4)=p(i+2,j)>=p(i+1,j);
        b(5)=p(i+1,j)>=p(i,j); b(6)=p(i,j)>=p(i,j+1);
        b(7)=p(i,j+1)>=p(i+1,j+1); b(8)=p(i+1,j+1)>=p(i+1,j+2);
        b(9)=p(i+1,j+2)>=p(i,j+2);b(10)=p(i,j+2)>=p(i,j+3);
        b(11)=p(i,j+3)>=p(i+1,j+3);b(12)=p(i+1,j+3)>=p(i+2,j+3);
        b(13)=p(i+2,j+3)>=p(i+2,j+2);b(14)=p(i+2,j+2)>=p(i+3,j+2);
        b(15)=p(i+3,j+2)>=p(i+3,j+3);b(16)=0;
       HC1(i,j)=0;
       if b(8)==1
        for ii=1:8
            HC1(i,j)=HC1(i,j)+(or(b(ii),b(ii+8)))*2^(8-ii);
        end
       else
          for ii=1:8
            HC1(i,j)=HC1(i,j)+(and(b(ii),b(ii+8)))*2^(8-ii);
          end
       end
    end
end
histo=imhist(uint8(HC1));