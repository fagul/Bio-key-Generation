load('feature_vector1.mat');
load('feature1.mat');
% binary_code=[];
result=[];
ar=[];
ar1=[];
dis=[];
dis1=[];
ange=[];
ange1=[];
in_center=[];
in_center1=[];
feature_vector_randomwalk=[];
len=[];
len1=[];
len2=[];
len3=[];
len4=[];
for k=1:9
    for l=1:8
        TRI=[];
        x=feature_vector1{k,l}(:,1);
        y=feature_vector1{k,l}(:,2);
        TRI = delaunay(x,y);
       
        TR = delaunayTriangulation(x,y);
      
        result{k,l}=TRI;
       
        for i=1:size(TRI,1)
           ar{k,l}(:,i)=tringl([feature_vector1{k,l}(TRI(i,1),:)],[feature_vector1{k,l}(TRI(i,2),:)],[feature_vector1{k,l}(TRI(i,3),:)]);     
           dis{k,l}(i,:)=leng([feature_vector1{k,l}(TRI(i,1),:)],[feature_vector1{k,l}(TRI(i,2),:)],[feature_vector1{k,l}(TRI(i,3),:)]); 
           ange{k,l}(i,:)=angl([feature_vector1{k,l}(TRI(i,1),:)],[feature_vector1{k,l}(TRI(i,2),:)],[feature_vector1{k,l}(TRI(i,3),:)]); 
           in_center{k,l}= incenter(TR);
        end
         ar1{k,l}=ar{k,l}./max(ar{k,l});
         len=[len,size(ar1{k,l},2)];
         dis1{k,l}=dis{k,l}./max(max(dis{k,l}));
         len1=[len1,size(dis1{k,l},1)];
         ange1{k,l}=ange{k,l}./max(max(ange{k,l}));
         len2=[len2,size(ange1{k,l},1)];
         for m=1:size(in_center{k,l},1)
           in_center1{k,l}(m,:)=in_center{k,l}(m,:)./max(in_center{k,l});
         end
         len3=[len3,size(in_center1{k,l},1)];
         
         for m1=1:size(feature_vector1{k,l},1)
           feature_vector1{k,l}(m1,:)=feature_vector1{k,l}(m1,:)./max(feature_vector1{k,l});
         end
          
        % feature_vector_randomwalk{k,l}=fft([ar1{k,l},reshape(dis1{k,l}',[],1)',reshape(ange1{k,l}',[],1)',reshape(in_center1{k,l}',[],1)',feature1{k,l}(3:3:30)/max(feature1{k,l}(3:3:30)),reshape(feature_vector1{k,l}',[],1)'],100);

    end
end

for k=1:9
    for l=1:8
     
      ar1{k,l}=sort(ar1{k,l});
      ar1{k,l}=ar1{k,l}(:,1:min(len));
      dis1{k,l}=sort(reshape(dis1{k,l}',[],1)');
      dis1{k,l}=dis1{k,l}(:,1:min(len1*3));
      ange1{k,l}=sort(reshape(ange1{k,l}',[],1)');
      ange1{k,l}=ange1{k,l}(:,1:min(len2*3));
      in_center1{k,l}=sort(reshape(in_center1{k,l}',[],1)');
      in_center1{k,l}=in_center1{k,l}(:,1:min(len3*2));
      for m1=1:size(feature_vector1{k,l},1)
           feature_vector1{k,l}(m1,:)=feature_vector1{k,l}(m1,:)./max(feature_vector1{k,l});
      end
     feature_vector_randomwalk{k,l}=[ar1{k,l},reshape(dis1{k,l}',[],1)',reshape(ange1{k,l}',[],1)',reshape(in_center1{k,l}',[],1)',feature1{k,l}(3:3:30)/max(feature1{k,l}(3:3:30)),reshape(feature_vector1{k,l}',[],1)'];

    end
end

