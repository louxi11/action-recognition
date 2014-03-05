function [trFeatures trResponses teFeatures teResponses] = loadFeature(dataPath)
% This function mainly preprocess features,including loading,tranformation
% Input:
%     dataPath        string (e.g.'\home\wangxz\DataSets\')
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

trC = fullfile(dataPath, 'trClassMats.mat');
teC = fullfile(dataPath, 'teClassMats.mat');
trR = fullfile(dataPath, 'trClassResponses.mat');
teR = fullfile(dataPath, 'teClassResponses.mat');
%% Load features and responses from files
if ~exist(trC,'file') || ~exist(teC,'file')...
    || ~exist(trR,'file') || ~exist(teR,'file')
    disp('No data found!');
    return;
end 
if ~exist('trClassMats', 'var') 
    load(trC);
    load(trR);
end
if ~exist('teClassMats', 'var')
    load(teC);
    load(teR);
end

%% Prepare train and test set
trFeatures = [];
teFeatures = [];
trResponses = [];
teResponses = [];

% Remove those videos who have no interest points
k = 0;
for i = 1 : length(trClassMats)
  ind2del = [];
  for j = 1 : length(trClassMats{i})
    if isempty(trClassMats{i}{j})
        ind2del = [ind2del; j];
        k = k + 1;
    end
  end
  if length(ind2del) > 0
     trClassMats{i}(ind2del) = [];
  end  
end

fprintf('\n%d train videos have been discarded.\n',k);

k = 0;
for i = 1 : length(teClassMats)
  ind2del = [];
  for j = 1 : length(teClassMats{i})
    if isempty(teClassMats{i}{j})
        ind2del = [ind2del; j];
        k = k + 1;
    end
  end
  if length(ind2del)>0
     teClassMats{i}(ind2del) = [];
  end  
end


fprintf('\n%d test videos have been discarded.\n',k);

for i = 1 : length(trClassMats)
    for j = 1 : length(trClassMats{i})
        trFeatures = [trFeatures; {trClassMats{i}{j}}];
        trResponses = [trResponses; {trClassResponses{1,i}}];
    end
end

for i = 1 : length(teClassMats)
    for j=1 : length(teClassMats{i})
        teFeatures = [teFeatures; {teClassMats{i}{j}}];
        teResponses = [teResponses; {teClassResponses{1,i}}];    
    end
end

end
