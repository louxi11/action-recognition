function [ center ] = my_kmeans(data, K)

t = tic;
redo = 1;
verbose = 0; % 0 - no output

% Number of videos
nVideo = size(data, 1);

dataInMat = single(cell2mat(data));

% Perform kmeans
center = yael_kmeans(dataInMat', K, 'redo', redo, 'verbose', verbose);
center = center';

% fprintf('K_means took %f seconds for every video.',toc(t)/redo/nVideo);

end
