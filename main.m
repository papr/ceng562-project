close all;
clear all;
clc;

loadtic = tic;
display('Loading trajectories...');
load('char-trajectories.mat');
loadtoc = toc(loadtic);
fprintf('Data loading took %d''%0.0f''''\n',floor(loadtoc/60),rem(loadtoc,60));

%%
% cross validation
%

totaltic = tic;

n = consts.N; % number of samples
cv = cvpartition(n,'KFold',10);
disp(cv);

correct = zeros(cv.NumTestSets,1);

for i=1:cv.NumTestSets
    maintic = tic;
    fprintf('\nExecute fold %d...\n',i);
    
    train_in = cv.training(i);
    test_in  = cv.test(i);
    
    fprintf('\tConstruct ESN input...\n');
    % construct time series
    [ u,EoTSidc,train_out,test_out,labels ] = ...
        construct_timeseries( mixout,consts.charlabels,train_in,test_in );

    fprintf('\tPerturbe reservoir...\n');
    % run esn with x neurons
    network_slices = esn(25,0.1,u,EoTSidc);
    drawnow;
    
    fprintf('\tFit k-nearest neighbours...\n');
    obj = fitcknn(network_slices(:,train_out)', labels(train_out)'); % fit discriminant function
    obj.NumNeighbors = 5;
    
    fprintf('\tTest knn prediction...\n');
    predictions = predict(obj,network_slices(:,test_out)'); % predict test values

    check = labels(test_out) - predictions';
    pos_count = sum(check==0);
    correct(i) = pos_count / size(predictions,1);

    maintoc = toc(maintic);
    fprintf('Fold %d took %d''%0.0f''''\n',i,floor(maintoc/60),rem(maintoc,60));
end

disp(correct');
fprintf('Avg Performance: %f\tStd Dev: %f\n',mean(correct(:)),std(correct(:)));
totaltoc = toc(totaltic);
fprintf('Total time: %d''%0.0f''''\n',floor(totaltoc/60),rem(totaltoc,60));
