%match_score
function [match_score]=template_match1(one_string,one_string1)
  
    bound(1)=size(one_string,2);
    bound(2)=size(one_string1,2);
    [mn,in]=min(bound);
   % mn
    if(in==2)
        
        match_score=((norm(one_string(:,1:mn)-one_string1))/((norm(one_string))+(norm(one_string1))));
%         match_score
    else
       match_score=((norm(one_string-one_string1(:,1:mn)))/((norm(one_string))+(norm(one_string1))));
%        match_score
    end
%     %%%%%%%%%%%%%%%
%     Ne=size(find(one_string),2);%no.of 1's enrolled
%     Nq=size(find(one_string1),2);%no.of 1's enrolled
% 
%     score=((Ne+Nq)*c)/((Ne*Ne)+(Nq*Nq));
match_score=1-match_score;
end