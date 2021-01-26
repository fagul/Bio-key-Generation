function Yp=KNN(train,l_train,test)
    for i=1:size(l_train,2)
        mdl =ClassificationKNN.fit(train,l_train(:,i));
        Yp(i,:) = predict(mdl,test);
    end
    Yp=Yp';
end
