MyFolderInfo = dir('DB1_B');
f1=[];
d1=[];
t=[];
m=1;
fc=[];
descList = {'BPPC','GDP','GDP2','GLTP','IWBC',...
            'LAP','LBP','LDiP','LDiPv','LDN',...
            'LDTP','LFD','LGBPHS','LGDiP','LGIP',...
            'LGP','LGTrP','LMP','LPQ','LTeP',...
            'LTrP','MBC','MBP','MRELBP','MTP',...
            'mWLD','PHOG'};
options.gridHist = 1;
de=23;
desc = descList{de};
descFunc = str2func(['desc_' desc]);
Descr_result1=[];
for image_no=3:length(MyFolderInfo)
     img = imread(MyFolderInfo(image_no).name);
    [feaIns, imgDesc] = descFunc(double(img),options);
    Descr_result1=[Descr_result1;feaIns];
end
%% 
feature1=[];
for i=1:10
    for j=1:8
      feature1{i,j}=Descr_result1((i-1)*8+j,:);
    end
end
fet=[];
feat=[];
%Descr_result1=Descr_result';
for i=1:10 %1,3,5,7
    fet(:,1:8)=[feature1{i,1}',feature1{i,3}',feature1{i,5}',feature1{i,7}',feature1{i,2}',feature1{i,4}',feature1{i,6}',feature1{i,8}'];
    feat(:,1)=(fet(:,1)-mean(mean(fet,2)));
   feat(:,2)=(fet(:,2)-mean(mean(fet,2)));
    feat(:,3)=(fet(:,3)-mean(mean(fet,2)));
    feat(:,4)=(fet(:,4)-mean(mean(fet,2)));
%      feat(:,5)=(fet(:,5)-mean(mean(fet,2)));
%    feat(:,6)=(fet(:,6)-mean(mean(fet,2)));
%    feat(:,7)=(fet(:,7)-mean(mean(fet,2)));
%     feat(:,8)=(fet(:,8)-mean(mean(fet,2)));
    
    weight_matrix1=cov(feat');
    %weight_matrix1=feat*feat';
    [V,D] =eigs(weight_matrix1',256);
    [d,ind] = sort(diag(D),'descend');
    d1=abs(d)<=10^2;
    d3{i}=d1;
    ind1=ind(d1);
     %d1=d;
    Ds = D(ind1,ind1);
    Vs = V(:,ind1);
    model.vs{i}=Vs';

end
for i=1:10
  for k=1:8
      q=0;
    projected_feature1{i}(:,k)=model.vs{i}*feature1{i,k}';
    q=projected_feature1{i}(:,k);
    save([num2str(i) '_' num2str(k) '.mat'],'q');
  end
end
desr=[];
for i=1:10
desr=[desr;projected_feature1{1,i}'];
end
A = zeros(80,4);
[rows columns] = size(A);
secondColumn = imresize((1:rows/8)', [rows, 1], 'nearest');
A(:, 2) = secondColumn;
%% 
y=secondColumn;
X=desr;
[m,n]=size(X);
for i=1:n
    X(:,i)=(X(:,i)-min(X(:,i)))/(max(X(:,i))-min(X(:,i))+eps);
end
diste=[];
for i=1:80
    for j=1:80
        diste(i,j)=1-norm(X(i,:)-X(j,:))/(norm(X(i,:))+norm(X(j,:)));
    end
end

[a,b]=relieff(X,y,10);
ss=1;
for i=1:length(a)
    if b(i)>0
        poz(:,ss)=X(:,i);
        ss=ss+1;
    end
end
mdl = fscnca(poz,y,'Solver','sgd','Verbose',1);
w=mdl.FeatureWeights;
[aa,ind]=sort(w,'desc');
tt=176;
for i=1:tt
    cd(:,i)=poz(:,ind(i));
end
cd(:,tt+1)=y;
for i=1:80
    for j=1:80
        dist(i,j)=1-norm(cd(i,:)-cd(j,:))/(norm(cd(i,:))+norm(cd(j,:)));
    end
end

cds=[];
cds=100*cd(:,1:tt);
result_cds=[];
for j=1:80
    for i=1:tt
        result_cds(j,i)=test_pointssss(round(cds(j,i)),2);
    end
end


 for i=1:80
    for j=1:80
        distcds(i,j)=1-norm(result_cds(i,:)-result_cds(j,:))/(norm(result_cds(i,:))+norm(result_cds(j,:)));
    end
 end
cd2=[];
for i=1:80
     for j=1:8:tt
        cd2(i,j:j+7)=test_ldp(result_cds(i,j:j+7));
        %cd2(i,:)=round(abs(cd1(i,:)));
      end
    
end 
 
result_db=[];
for i=1:80
    for j=1:80
        result_db(i,j)=sum(cd2(i,:)==cd2(j,:))/176;
    end
end
resl=[];
g=1;
d2=cd2;
for f=1:8:80
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
for i=1:10
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
    rest(i)=(length(find((s1(:,i))==i))>=10);
end
key=find(rest);

cd3=cd2(:,key);

result_db1=[];
for i=1:80
    for j=1:80
        result_db1(i,j)=sum(cd3(i,:)==cd3(j,:))/length(key);
    end
end