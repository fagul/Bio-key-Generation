%
%   Example:
%       option.gridHist = [2,4];
%       options.mode = 'nh';
%       options.t = 11;
%       feaHist = desc_GLTP(img,options)
%
close all
clear all
clc
addpath('descFuncs');
addpath('sideFuncs');
descList = {'BPPC','GDP','GDP2','GLTP','IWBC',...
            'LAP','LBP','LDiP','LDiPv','LDN',...
            'LDTP','LFD','LGBPHS','LGDiP','LGIP',...
            'LGP','LGTrP','LMP','LPQ','LTeP',...
            'LTrP','MBC','MBP','MRELBP','MTP',...
            'mWLD','PHOG'};
options.gridHist = 1;
X=[];
y=[];
for k=1:9
imList = dir(['./00' num2str(k) '/*.bmp']);
Features = struct;
for de = 27%: length(descList)
    desc = descList{de};
    descFunc = str2func(['desc_' desc]); display(char(descFunc));
    Features.(desc) = [];
    for im = 1: length(imList)
        display(char(num2str(im)))
        imName = ['./00' num2str(k) '/' imList(im).name];
        img = imread(imName);
        [feaIns, imgDesc] = descFunc(double(img),options);
        Features.(desc) = vertcat(Features.(desc),feaIns);
        y=[y;k];
    end
    
   X=[X;Features.(desc)];
end

end
[m,n]=size(X);
for i=1:n
    X(:,i)=(X(:,i)-min(X(:,i)))/(max(X(:,i))-min(X(:,i))+eps);
end
diste=[];
for i=1:90
    for j=1:90
        diste(i,j)=1-norm(X(i,:)-X(j,:))/(norm(X(i,:))+norm(X(j,:)));
    end
end

[a,b]=relieff(X,y,90);
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
tt=100;
for i=1:tt
    cd(:,i)=poz(:,ind(i));
end
cd(:,tt+1)=y;
for i=1:90
    for j=1:90
        dist(i,j)=1-norm(cd(i,:)-cd(j,:))/(norm(cd(i,:))+norm(cd(j,:)));
    end
end
%%%%%%%%%%%%%%%%%

train_dt=cd(1:2:90,1:100);
train_lb=cd(1:2:90,101);

test_dt=cd(setdiff([1:90],[1:2:90]),1:100);
test_lb=cd(setdiff([1:90],[1:2:90]),101);

params        = struct();
params.knn    = 5; % number of neighbors
params.k1     = 5;
params.k2     = 5;
params.kernel = 0; % no kernel trick is used
xTr=train_dt';
yTr=train_lb;
xTe=test_dt';
yTe=test_lb;
% training DMLMJ
L = DMLMJ(xTr, yTr, params);

%%%%%%%%%%%%%%%%%%%%%%
Xtr1=L'*xTr;
Xte1=L'*xTe;
X1=L'*cd(:,1:100)';
dist1=[];
cd1=X1';
for i=1:90
    for j=1:90
        dist1(i,j)=1-norm(cd1(i,:)-cd1(j,:))/(norm(cd1(i,:))+norm(cd1(j,:)));
    end
end
res=[];
for j=1:90
    cd2=[];
 for i=1:8:100
   cd2=[cd2,test_ldp(cd1(j,i:i+7))];
 end
 res=[res;cd2];
end
% test_dr=L'*cd';
dist2=[];
for i=1:90
    for j=1:90
        dist2(i,j)=jaccard(res(i,:),res(j,:));
        %1-norm(res(i,:)-res(j,:))/(norm(res(i,:))+norm(res(j,:)));
    end
end

pred1 = knnClassifier(L'*xTr, yTr, 5, L'*xTe);
pred2 = knnClassifier(xTr, yTr, 5, xTe);

fprintf('\n----------------------------------------------\n');
fprintf('Euclidean accuracy = %.2f\n', sum(pred2 == yTe)/length(yTe)*100);
fprintf('DMLMJ accuracy = %.2f\n',     sum(pred1 == yTe)/length(yTe)*100);