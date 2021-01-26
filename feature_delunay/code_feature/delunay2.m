load('feature_vector1.mat');
load('feature1.mat');
% binary_code=[];
result=[];
ar=[];
dis=[];
ange=[];
in_center=[];
feature_vector_randomwalk=[];
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
         ar{k,l}=ar{k,l}./max(ar{k,l});
         dis{k,l}=dis{k,l}./max(max(dis{k,l}));
         ange{k,l}=ange{k,l}./max(max(ange{k,l}));
         for m=1:size(in_center{k,l},1)
           in_center{k,l}(m,:)=in_center{k,l}(m,:)./max(in_center{k,l});
         end
         for m1=1:size(feature_vector1{k,l},1)
           feature_vector1{k,l}(m1,:)=feature_vector1{k,l}(m1,:)./max(feature_vector1{k,l});
         end
         
         feature_vector_randomwalk{k,l}=fft([ar{k,l},reshape(dis{k,l}',[],1)',reshape(ange{k,l}',[],1)',reshape(in_center{k,l}',[],1)',feature1{k,l}(3:3:30)/max(feature1{k,l}(3:3:30)),reshape(feature_vector1{k,l}',[],1)'],120);

    end
end



