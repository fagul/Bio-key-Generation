MyFolderInfo = dir('df');
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
de=20;%%%%Local ternary pattern
desc = descList{de};
descFunc = str2func(['desc_' desc]);
Descr_result1=[];
for image_no=3:length(MyFolderInfo)
     img = imread(MyFolderInfo(image_no).name);
    [feaIns, imgDesc] = descFunc(double(img),options);
    Descr_result1=[Descr_result1;feaIns];
end
d4=zscore(Descr_result1);

A = zeros(4,4);
[rows columns] = size(A);
secondColumn = imresize((1:rows/1)', [rows, 1], 'nearest');
A(:, 2) = secondColumn;
%% 
y=secondColumn;
X=Descr_result1;
[m,n]=size(X);
for i=1:n
    X(:,i)=(X(:,i)-min(X(:,i)))/(max(X(:,i))-min(X(:,i))+eps);
end
diste=[];
for i=1:4
    for j=1:4
        diste(i,j)=1-norm(X(i,:)-X(j,:))/(norm(X(i,:))+norm(X(j,:)));
    end
end