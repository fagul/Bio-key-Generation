%Pseudo-genuniue scores:
function [gen,sequence]=pseudo_genuinue()
d=load('cd3.mat');
d1=load('nonps2.mat');
key=[d.cd3,d1.cd3,d1.cd3,d1.cd3];
load('cd3db2_b.mat');
d2=load('delunay1.mat');
key1=[cd3,d2.cd3,d2.cd3,d2.cd3];
gen=[];
sequence=[];
 for i = 1:9
    combination = nchoosek(1:8, 2);    
     for j = 1:length(combination)
        file1 = combination(j,:);
        sequence=[sequence;[(i-1)*8+file1(1) ,(i-1)*8+file1(2)]];
        template1=key((i-1)*8+file1(1),:);
      
        template2=key1((i-1)*8+file1(2),:);
       
        C2=template_match1(template1,template2);
        similiraty=C2;
        gen = [gen; similiraty];
     end
 end
end