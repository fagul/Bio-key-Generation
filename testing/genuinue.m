%Pseudo-genuniue scores:
function [genuine,sequence]=genuinue()
load('output_signal_two_three.mat');
key1=output_signal_two_three;
genuine=[];
sequence=[];
 for i = 1:9
    combination = nchoosek(1:8, 2);    
     for j = 1:length(combination)
        file1 = combination(j,:);
        sequence=[sequence;[(i-1)*8+file1(1) ,(i-1)*8+file1(2)]];
        template1=key1((i-1)*8+file1(1),:);
      
        template2=key1((i-1)*8+file1(2),:);
       
        C2=template_match1(template1,template2);
        
        similiraty=C2;
        genuine = [genuine; similiraty];
     end
 end
