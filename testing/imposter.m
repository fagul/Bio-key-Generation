function [impo1,sequence]=imposter()
load('output_signal_two_three.mat');
key1=output_signal_two_three;
impo1=[];
sequence=[];
combination = nchoosek(1:9, 2);
for i = 1:8
    for j = 1:length(combination)
        file1 = combination(j,:);
        sequence=[sequence;[8*(file1(1)-1)+i ,8*(file1(2)-1)+i]];
        template1=key1(8*(file1(1)-1)+i,:);
        template2=key1(8*(file1(2)-1)+i,:);
        C2=template_match1(template1,template2);
        similiraty=C2;
        impo1 = [impo1; similiraty];
    end
end
end