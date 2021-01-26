load('cd3db2_b.mat');
d=load('cd3db2_b.mat');
d1=load('delunay1.mat');
d2=load('cd3.mat');
dt=[cd3,d.cd3,d1.cd3,d2.cd3];
for i=1:8
    for j=9:72
     dist(i,j)=1024-sum(dt(i,1:1024)==dt(j,1:1024));
    end
end

% for i=9:18
%     for j=19:72
%      dist(i,j)=sum(cd3(i,:)==cd3(j,:));
%     end
% end

ds=dist(find(dist~=0));
histfit(ds); hold on
xlabel('Hamming distance(inter-class)');
ylabel('Frequency');
title('Dissimilarity analysis');
% [f,xi] = ksdensity(ds);
% hold on
% plot(xi,f)
% hist(dist,452);
% yourChargeArray=dist;
% histogram(yourChargeArray); % Display histogram
% countOfCharges = sum(yourChargeArray(:) ~= 0)
% totalCharges = sum(yourChargeArray(:))
% averageChargeValue = mean(yourChargeArray(:));
% maxChargeValue = max(yourChargeArray(:));