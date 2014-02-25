function [trFeatures trResponses teFeatures teResponses] = loadFeature(dataPath)
% This function mainly preprocess features,including loading,tranformation
% Input:
%     dataPath        string (e.g.'/home/wangxz/dataset')
%    
% Output:
%     trFeatures      cell vector (e.g. 382*1 cell probably global)
%                     each cell represents a video, double matrix (e.g. 
%                     278*90 double which means the video has 278 stips 
%                     and each point is 90 a dimensional vector)
%     trResponses     cell vector (e.g. 382*1 cell probably global)
%                     each cell represents a video's tag, int (e.g. 1)
%     teFeatures      cell vector (e.g. 216*1 cell probably global)
%                     each cell represents a video, double matrix (e.g. 
%                     609*90 double which means the video has 609 stips 
%                     and each point is 90 a dimensional vector)
%     teResponses     cell vector (e.g. 216*1 cell probably global)
%                     each cell represents a video's tag, int (e.g. 1)
% Note:
%     the size of trFeatures and trReponses are the same, so is teFeatures
%     and teResonses.

personsMats = [];
personsResponses = [];

% Load features and responses
load(fullfile(dataPath,'personsMats.mat'));
load(fullfile(dataPath,'personsResponses.mat'));

% for i = 1:length(personsMats)
%    for j = 1:length(personsMats{i})
%        t = personsMats{i}{j};
%        for k = 1:size(t,1)
%            t(k, :) = t(k,:)./norm(t(k, :));
%        end
%        personsMats{i}{j} = t;
%    end
% end

% Train/Test set separation
testIds = [2,3,5,6,7,8,9,10,22];
trainingIds = setdiff(1:25, testIds);

trFeatures = [];
trResponses = []; 
teFeatures = [];
teResponses = [];

for i=1 : size(trainingIds, 2)
    trFeatures = [trFeatures; personsMats{trainingIds(i)}];
    trResponses = [trResponses; personsResponses{trainingIds(i)}];
end

for i=1 : size(testIds, 2)
    teFeatures = [teFeatures; personsMats{testIds(i)}];
    teResponses = [teResponses; personsResponses{testIds(i)}];
end

end % End of function
