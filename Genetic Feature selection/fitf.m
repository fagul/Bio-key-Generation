function acc=fitf(sub)
    global orgfeatures labels alg
    features=orgfeatures(:,sub);
    acc=evl(features,labels,alg);
end