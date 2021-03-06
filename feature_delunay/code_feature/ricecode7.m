s=load('feature_vector_randomwalk2update.mat');
binary_code=[];
% result=[];
feature1=s.feature_vector_randomwalk;
fet=[];
feat=[];
d3=[];
for i=1:9
    fet(:,1:5)=[feature1{i,1}(:,1:120)',feature1{i,2}(:,1:120)',feature1{i,3}(:,1:120)',feature1{i,5}(:,1:120)',feature1{i,7}(:,1:120)'];
    feat(:,1)=(fet(:,1)-mean(mean(fet,2)));
    feat(:,2)=(fet(:,2)-mean(mean(fet,2)));
    feat(:,3)=(fet(:,3)-mean(mean(fet,2)));
    %feat(:,4)=(fet(:,4)-mean(mean(fet,2)));
    %feat(:,5)=(fet(:,5)-mean(mean(fet,2)));
    
    weight_matrix1=cov(feat');
    %weight_matrix1=feat*feat';
    [V,D] =eigs(weight_matrix1',120);
    [d,ind] = sort(diag(D),'descend');
    d1=abs(d)<=10^2;
    d3{i}=d1;
    ind1=ind(d1);
     %d1=d;
    Ds = D(ind1,ind1);
    Vs = V(:,ind1);
    temp_project=[];
    for k=1:8
       temp_project=[temp_project,Vs'*feature1{i,k}(:,1:120)'];
    end
    projected_feature{i}=temp_project;
    projected_feature_binary{i}=mod(round(temp_project),4);
   
end
d2=cell2mat(projected_feature);
d3=d2';
dist1=[];
for i=1:72
    for j=1:72
      dist1(i,j)=norm(d2(:,i)-d2(:,j));
    end
end

