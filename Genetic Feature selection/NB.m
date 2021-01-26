function Yp=NB(train,train_lab,test)
model=fitcknn(train,train_lab);
Yp=predict(model,test);
end