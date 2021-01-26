load('cds.mat');
cd2=[];
tt=504;
for i=1:72
     for j=1:12:tt
        cd2(i,j:j+11)=test_ldp1(cds(i,j:j+11));
        %cd2(i,:)=round(abs(cd1(i,:)));
      end
    
end 
 %cd2=result_cds;
result_db=[];
for i=1:72
    for j=1:72
        result_db(i,j)=sum(cd2(i,:)==cd2(j,:))/size(cd2,2);
    end
end
resl=[];
g=1;
d2=cd2;
for f=1:8:72
 k=1;
 diste1=[];
for i=f:f+7
    for j=f:f+7
      diste1{k}=find(d2(i,:)==d2(j,:));
      k=k+1;
    end
end
s=zeros(64,tt);
for i=1:64
      for j=1:size(diste1{i},2)
          for k=1:tt
            if(diste1{i}(j)==k)  
               s(i,k)=k;
            end
          end
      end
end
res=[];
for i=1:tt
    res(i)=all((s(:,i)));
end

resl{g}=find(res==1);
g=g+1;
end
s1=[];
for i=1:9
      for j=1:size(resl{1,i},2)
          for k=1:tt
            if(resl{1,i}(j)==k)  
               s1(i,k)=k;
            end
          end
      end
end
rest=[];
for i=1:tt
    rest(i)=(length(find((s1(:,i))==i))>=5);
end
key=[];
key=find(rest);
cd3=[];
cd3=cd2(:,key);

result_db1=[];
for i=1:72
    for j=1:72
        result_db1(i,j)=sum(cd3(i,:)==cd3(j,:))/size(cd3,2);
    end
end
%%%%%%%%%%
t=toc;