load('FVC2002_DB1feature.mat');
load('FVC2002_DB1_core.mat');
a=(1:3:30);
b=(3:3:30);
for k=1:9
  for l=1:8
      s1=[];
      for i=1:length(a)
          s1=[s1;feature1{k,l}(1,a(i):a(i)+1)];
      end
    feature_vector1{k,l}=s1; 
    feature_vector11{k,l}=feature1{k,l}(b);
  end
end
% binary_code=[];
result=[];
ar=[];
dis=[];
ange=[];
in_cntr=[];
in_center=[];
feature_vector_randomwalk=[];
for k=1:9
    for l=1:8
        TRI=[];
        x=feature_vector1{k,l}(:,1);
        y=feature_vector1{k,l}(:,2);
        TRI = delaunay(x,y);
        
        TR = delaunayTriangulation(x,y);
        
        triplot(TR,'color','k','LineWidth',2); hold on
        ic=incenter(TR);
        axis equal;
        %axis([-0.2 1.2 -0.2 1.2]);
        hold on; plot(ic(:,1),ic(:,2),'*b'); hold off;
        
        result{k,l}=TRI;
        for i=1:size(TRI,1)
           in_cntr{k,l}=incenter(TR);
           B=d_core{k,l}(1,1:2);
           A=in_cntr{k,l};
           Dist = sqrt(sum((A - B) .^ 2, 2));
        end
        [D,in]=sort(Dist);
        
        for i=1:10
           ar{k,l}(:,i)=tringl([feature_vector1{k,l}(TRI(in(i),1),:)],[feature_vector1{k,l}(TRI(in(i),2),:)],[feature_vector1{k,l}(TRI(in(i),3),:)]);     
           dis{k,l}(i,:)=leng([feature_vector1{k,l}(TRI(in(i),1),:)],[feature_vector1{k,l}(TRI(in(i),2),:)],[feature_vector1{k,l}(TRI(in(i),3),:)]); 
           ange{k,l}(i,:)=angl([feature_vector1{k,l}(TRI(in(i),1),:)],[feature_vector1{k,l}(TRI(in(i),2),:)],[feature_vector1{k,l}(TRI(in(i),3),:)]); 
           in_center{k,l}=in_cntr{k,l}(in(1:10)',:);
           
        end
         ar{k,l}=ar{k,l}./max(ar{k,l});
         dis{k,l}=dis{k,l}./max(max(dis{k,l}));
         ange{k,l}=ange{k,l}./max(max(ange{k,l}));
         for m=1:size(in_center{k,l},1)
           in_center{k,l}(m,:)=in_center{k,l}(m,:)./max(in_center{k,l});
         end
         for m1=1:size(feature_vector1{k,l},1)
           feature_vector1{k,l}(m1,:)=feature_vector1{k,l}(m1,:)./max(feature_vector1{k,l});
         end
         feature_vector_randomwalk{k,l}=[ar{k,l},reshape(dis{k,l}',[],1)',reshape(ange{k,l}',[],1)',reshape(in_center{k,l}',[],1)',feature1{k,l}(3:3:30)/max(feature1{k,l}(3:3:30)),reshape(feature_vector1{k,l}',[],1)'];

    end
end
%save('DB2Dfeature.mat','feature_vector_randomwalk');


