%Feature vector 72*120 from Delunay- 1 dataset
%% 
load('FVC2002DB2_BLTPtexturefeature.mat');
d1=load('FVC2002_DB2Delunayfeature.mat');
d2=load('FVC2002DB2_BMTPtexturefeature.mat');
feature=[d4,d1.d4,d2.d4];
%% 
%%% label 72*1 for each instance
A = zeros(72,4);
[rows columns] = size(A);
secondColumn = imresize((1:rows/8)', [rows, 1], 'nearest');
A(:, 2) = secondColumn;
%% 
%%distance calculation
%% 
for i=1:72
    for j=1:72
        dist2(i,j)=1-norm(feature(i,:)-feature(j,:))/(norm(feature(i,:))+norm(feature(j,:)));
    end
end
%% Metric learning
num_folds = 2;
knn_neighbor_size = 4;
sec=[1:2:72];%% training instances 1,3,5,7 of each fingerprint
%%%Metric generation
%% 
a=MetricLearningAutotuneKnn(@ItmlAlg, secondColumn(sec,:), feature(sec,:));
%% discriminate feature vector generation
%%%%%%
result_X=feature*a;
%% Discriminate check.
for i=1:72
    for j=1:72
        dist(i,j)=1-norm(result_X(i,:)-result_X(j,:))/(norm(result_X(i,:))+norm(result_X(j,:)));
end
end
tt=1144;
%% Key generation
cds=[];
cds=100*abs(result_X(:,1:tt));
% result_cds=[];
% for j=1:72
%     for i=1:tt
%         result_cds(j,i)=test_pointssss(round(cds(j,i)),10);
%     end
% end
% 
% 
%  for i=1:72
%     for j=1:72
%         distcds(i,j)=1-norm(result_cds(i,:)-result_cds(j,:))/(norm(result_cds(i,:))+norm(result_cds(j,:)));
%     end
%  end
cd2=[];
for i=1:72
     for j=1:8:tt
        cd2(i,j:j+7)=test_ldp(cds(i,j:j+7));
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
