function Yp=DT(train,l_train,test)
    tree =ClassificationTree.fit(train,l_train);
    Yp = predict(tree,test);
end