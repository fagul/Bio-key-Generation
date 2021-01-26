function accuracy = evaluation(result,l_test)

    accuracy=sum(result==l_test)/numel(result);
   
end