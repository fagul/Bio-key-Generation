function [Yp,net]=NN(trn,l_train,test)
    p=trn; % Train Data
    p=p';
    T=l_train; % Target Data (Labels)
    T=T';
    net = feedforwardnet(10,'trainlm');
    net = train(net,p,T);
    p2= test';
    Y2 = net(p2); % Result Labels for Test Data
    Yp= fix(Y2);
    Yp=Yp';
end