function [ vectors ] = getVideoRepreVLAD( features, center )
% Use VLAD to form the representation of the videos
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

nVideo = size(features,1);
center = center';
histograms = cell(nVideo,1);
for i=1:nVideo
    videoFeature = features{i};
    histograms{i} = VLAD(center, videoFeature');       
end
vectors = cell2mat(histograms);

end



function [representation] = VLAD(center, features)   
% center            matrix like 162*5000, each center per column
% features          matrix like 162*278, each feature point per column
% representation    vector like 1*(5000*162=810000)

ncenter = size(center, 2);
nfeature = size(features, 2);
feature_dim = size(features, 1);
centerRepsentation = zeros(feature_dim, ncenter);
[ids,~] = yael_nn(center, single(features), 1, 2);

for t=1:nfeature
    i = ids(t);
    centerRepsentation(:,i) = centerRepsentation(:,i) + features(:,t) - center(:,i);
end

representation = normc(sign(centerRepsentation(:)).*(abs(centerRepsentation(:)).^0.5))';

end
