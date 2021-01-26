%% Genetic Algorithm for Feature Selection in classification problems. 
clear all;
close all;
clc;
%%
global orgfeatures labels alg
% load desrMBP.mat %256
% features=desr;
% A = zeros(80,4);
% [rows columns] = size(A);
% secondColumn = imresize((1:rows/8)', [rows, 1], 'nearest');
% A(:, 2) = secondColumn;
% labels=secondColumn;
load DB.mat
orgfeatures=features;
%% initialization:
algorithms='KNN'; %{'KNN','NB','DT','NN'}
npop=10; % initial population size
max_generation=100;
Nf=size(features,2); % # of features
%%
alg=algorithms;
for i=1:npop
    solutions{i}=make_solution(Nf);
end
soluion1=[];
solution1=solutions;
for t=1:max_generation
    for i=1:npop
        fitness(i)=fitf(solutions{i});
    end
    if rem(t,10)==0
        disp(['Searching...',num2str(t/max_generation*100),'%  , accuracy= ',num2str(max(fitness))]);
    end
    [~,idx]=sort(fitness);
%     plot(t,fitness(idx(end)),'o');
%     hold on
%     pause(0.00000001);
%     xlabel('iteration');
%     ylabel('Accuracy');
    best_solution=solutions{idx(end)};
    best_solution2=solutions{idx(end-1)};
    solutions{idx(1)}=GASearch(best_solution,best_solution2,Nf); 
    solutions{idx(2)}=GASearch(best_solution2,best_solution,Nf);
end
disp('------------------------------');
algorithm=alg
Accuracy_byAll=fitf(1:Nf)
Accuracy_After_GA=fitf(best_solution)
reduced_features=Nf-size(best_solution,2)
best_features=best_solution
