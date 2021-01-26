function sol=GASearch(s1,s2,Nf)
    % making chromosome 
    sol1=zeros(1,Nf);
    sol2=sol1;
    for i=1:Nf
        for j=1:length(s1)
            if i==s1(j)
                sol1(i)=1;
                break;
            else
                sol1(i)=0;
            end
        end
        for j=1:length(s2)
            if i==s2(j)
                sol2(i)=1;
                break;
            else
                sol2(i)=0;
            end
        end
    end
    %crossover
    n=randsrc(1,1,1:0.5*Nf);
    m=randsrc(1,n,1:Nf);
    temp=sol1;
    sol1(m)=sol2(m);
    sol2(m)=temp(m);
    % Mutate
    if rand>0.5
        n=randsrc(1,1,1:0.25*Nf);
        m=randsrc(1,n,1:Nf);
        sol1(m)=randsrc(1,n,0:1);
        sol2(m)=randsrc(1,n,0:1);
    end
    solution1=find(sol1==1);
    solution2=find(sol2==1);
    if fitf(solution1)>fitf(solution2)
        sol=solution1;
    else
        sol=solution2;
    end
    
end