function [impo,sequence]=pseudo_imposter()
d=load('cd3.mat');
d1=load('nonps2.mat');
key=[d.cd3,d1.cd3,d1.cd3,d1.cd3];
load('cd3db2_b.mat');
d2=load('delunay1.mat');
key1=[cd3,d2.cd3,d2.cd3,d2.cd3];
impo=[];
sequence=[];
combination = nchoosek(1:9, 2);
for i = 1:8
    for j = 1:length(combination)
        file1 = combination(j,:);
        sequence=[sequence;[8*(file1(1)-1)+i ,8*(file1(2)-1)+i]];
        template1=key(8*(file1(1)-1)+i,:);
        template2=key1(8*(file1(2)-1)+i,:);
        C2=template_match1(template1,template2);
        similiraty=C2;
        impo = [impo; similiraty];
    end
end
end