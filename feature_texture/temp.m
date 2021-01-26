result_X=cd3;
for i=1:72
    for j=1:72
        dist(i,j)=1-norm(result_X(i,:)-result_X(j,:))/(norm(result_X(i,:))+norm(result_X(j,:)));
end
end