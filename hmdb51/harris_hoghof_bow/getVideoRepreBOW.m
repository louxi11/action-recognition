function [ vectors ] = getVideoRepresentationBOW( features, center )
% Use bow to form the histogram of the videos
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
nWord = size(center,1);
center = center';
histograms = cell(nVideo,1);
for i=1:nVideo
    videoFeature = features{i};
    nVideoFeature = size(videoFeature,1);
    [ids,~] = yael_nn(center, single(videoFeature)',1,2);
    histogram = accumarray(ids', ones(nVideoFeature,1), [nWord,1]);  
%     histograms{i} = normc(histogram)';
    histograms{i} = normc(sign(histogram).*(abs(histogram).^0.5))';
end
vectors = cell2mat(histograms);
end
