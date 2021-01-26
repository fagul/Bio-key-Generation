function A=make_solution(Nf)
    m=randsrc(1,1,1:0.75*Nf);% create a 1 value between 1 to 0.75*Nf 
    A=randperm(Nf,m);% selct m random value from Nf.
 end