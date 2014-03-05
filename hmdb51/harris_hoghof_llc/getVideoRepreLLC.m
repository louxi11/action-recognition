function [ vectors ] = getVideoRepreLLC( features, center )
% Use LLC to form the representation of the videos
% Input
%   features        a vector like(382*1 cell), each cell represent an
%                   video, it is a matrix like (278*90 double). it means
%                   the 1st video has 278 feature points.
%
%   center          a matrix like(4000*90 single),#row represent how many
%                   centers there are. #coloumn represents each center's
%                   dim exmple means there are 4000 centers, and each center
%                   has 90 dimension.
% Output
%   vectors         a matrix like (382*4000 double), #row means video number,
%                   #column means the video representation.


nVideo = size(features, 1);

% Transpose center
center = center';

% Form sparse codes
t = tic;
sparseCodes = cell(nVideo, 1);
for i = 1 : nVideo   % here can use parfor to improve performance
    videoFeatures = features{i};
    LLCCodes = LLC_coding_appr(center', videoFeatures);
    sparseCode = normr(sum(abs(LLCCodes), 1));
%     sparseCode = normc(max(LLCCodes, [], 1));
    sparseCodes{i} = sparseCode;

%   sparseCode = sum(abs(LLCCodes), 1)';
   %sparseCode = max(LLCCodes, [], 1);
%   sparseCodes{i} = normc(sign(sparseCode).*(abs(sparseCode).^0.5))';
end
   vectors = cell2mat(sparseCodes);
end
