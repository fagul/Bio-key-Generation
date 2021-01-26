MyFolderInfo = dir('db2');
f1=[];
d1=[];
t=[];
m=1;
fc=[];
quality=[];
for image_no=3:length(MyFolderInfo)
    
name_image_1=MyFolderInfo(image_no).name;
offsets0 = [zeros(40,1) (1:40)'];
im=imread(name_image_1);
%im=rgb2gray(imread('SM.jpg'));    %some image
fun = @(block_struct) graycomatrix(block_struct.data,'Offset',offsets0);
im2=blockproc(im,[32 32],fun);
%glcms = graycomatrix(imread(name_image_1),'Offset',offsets0);
% glcms=graycomatrix(imread(name_image_1));
%stats=GLCM_Features1(glcms,0);
stats = graycoprops(im2,'Contrast Correlation Energy Homogeneity');
fc=[fc;[stats.Correlation,stats.Energy,stats.Homogeneity]];
 %fc=[fc;[stats.Correlation]];
% [out, qmap] = fpqualityInterface('NFIQ',imread(name_image_1));
%quality=[quality;[niqe(imread(name_image_1)),lqm1(imread(name_image_1)),lqm2(imread(name_image_1))]];
end
diste=[];
for i=1:10
    for j=1:10
        diste(i,j)=1-norm(fc(i,:)-fc(j,:))/(norm(fc(i,:))+norm(fc(j,:)));
    end
end
% sec=[1:2:80];
% x=fc(sec,:);
% A = zeros(80,4);
% [rows columns] = size(A);
% secondColumn = imresize((1:rows/8)', [rows, 1], 'nearest');
% A(:, 2) = secondColumn;
% y=secondColumn(sec);
% Model=svm.train(x,y);
% predict=svm.predict(Model,fc);
% t = all(isnan(diste),2);
% t1=find(t)';
% d=[];
% for i=1:length(t1)
%  d{i}=MyFolderInfo(t1(i)+2).name;
% end
% figure, plot([stats.corrp]);
% title('Texture Correlation as a function of offset');
% xlabel('Horizontal Offset')
% ylabel('Correlation')