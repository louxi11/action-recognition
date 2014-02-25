function [acc] = framework(centerNums, para)
% Description : hof + bow + l-svm

dataPath = para.dataPath;
acc = zeros(1, length(centerNums));

%% Load data
[trFeatures, trResponses, teFeatures, teResponses] = loadFeature(dataPath);

% Remove hog from (hog-72,hof-90)
for i = 1:length(trFeatures)
    trFeatures{i}(:, 1:72) = [];
end
for i = 1:length(teFeatures)
    teFeatures{i}(:, 1:72) = [];
end


for i = 1:length(centerNums)
    iterBegin = tic;
    ncenter = centerNums(i);
    fprintf('center = %d\n', ncenter);
    center = getCenter(trFeatures, ncenter, para);

    trSamples = getVideoRepreLLC(trFeatures, center);
    teSamples = getVideoRepreLLC(teFeatures, center);

    %% Train SVM
    trLabel = cell2mat(trResponses);
    svm = svmtrain(trLabel, trSamples, '-t 0 -q');

    %% Test with trained model
    teLabel = cell2mat(teResponses);
    [predicted_label, stats, ~] = svmpredict(teLabel, teSamples, svm, '-q');

    %% Print result
    acc(i) = stats(1);
    fprintf('Accuracy is %.2f%%\n', acc(i));
    time = toc(iterBegin);
    fprintf('Current iter runs %.0f s', time);
    if time > 100 
        fprintf('(about %.0f min)', time/60);
    end
    fprintf('\n');

    disp('confusion matrix is:');
    disp(getConfusionMatrix(6, predicted_label, teLabel));
    fprintf('----------------------\n');
end

end % End of framework



function [center] = getCenter(data, k, para) 
% Description : Either load center from file or compute and save it if needed
%
% center,data : sample per column?
%           k : center number

cPath = fullfile(para.dataPath, para.centerDir);
cFilename = ['center_', num2str(k),'.mat'];
cPathFull = fullfile(cPath, cFilename);
center = []; % It will be computed or loaded from file.

if para.isLoadCenter
    if exist(cPathFull, 'file')==2
        load (cPathFull);
    else
        error('Error, cannot load center as center do not exist!\n');
    end
else 
    tic;
    center = my_kmeans(data, k);
    fprintf('Kmeans takes time: %.0f s.\n', toc);
    if para.isSaveCenter
        if ~exist(cPath, 'dir')
            mkdir(cPath);
        end    
        save(cPathFull, 'center');
    end    
end 

end % End of getCenter
