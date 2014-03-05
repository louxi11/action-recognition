function extract_kth(dir_path)
% The features are computed one by one, and each one in a single line, with the following format:
% frameNum mean_x mean_y var_x var_y length scale x_pos y_pos t_pos Trajectory HOG HOF MBHx MBHy
%
% The first 10 elements are information about the trajectory:
%
% frameNum:     The trajectory ends on which frame
% mean_x:       The mean value of the x coordinates of the trajectory
% mean_y:       The mean value of the y coordinates of the trajectory
% var_x:        The variance of the x coordinates of the trajectory
% var_y:        The variance of the y coordinates of the trajectory
% length:       The length of the trajectory
% scale:        The trajectory is computed on which scale
% x_pos:        The normalized x position w.r.t. the video (0~0.999), for spatio-temporal pyramid
% y_pos:        The normalized y position w.r.t. the video (0~0.999), for spatio-temporal pyramid
% t_pos:        The normalized t position w.r.t. the video (0~0.999), for spatio-temporal pyramid
% The following element are five descriptors concatenated one by one:
%
% Trajectory:    2x[trajectory length] (default 30 dimension)
% HOG:           8x[spatial cells]x[spatial cells]x[temporal cells] (default 96 dimension)
% HOF:           9x[spatial cells]x[spatial cells]x[temporal cells] (default 108 dimension)
% MBHx:          8x[spatial cells]x[spatial cells]x[temporal cells] (default 96 dimension)
% MBHy:          8x[spatial cells]x[spatial cells]x[temporal cells] (default 96 dimension)

% MBH: 10+30+96+108=244  244+96*2=436  so: HOG(40:40+96) HOF(137:137+108) MBH(245:436)
programBegin = tic;

% Person numbers
n = 25;

% Persons matrices and responses
personsMats = cell(1, n);
personsResponses = cell(1, n);

map = containers.Map();
map('boxing') = 1;
map('handclapping') = 2;
map('handwaving') = 3;
map('jogging') = 4;
map('running') = 5;
map('walking') = 6;

files = dir([dir_path '/*.txt']);
nVideo = length(files);
data = cell(1, nVideo);

% matlabpool local 10

for i = 1 : nVideo
    fprintf('\nstart to process No. %d video...\n', i);

    t_start = tic;
    [fea, pid, claName] = transSingle(fullfile(dir_path, files(i).name));
    temp = [{fea},{pid},{claName}];
    data{i} = temp;

    fprintf('No. %d video completed, takes time: %.0f min\n', i, toc(t_start)/60);
end

% matlabpool close

for i = 1 : nVideo
    if ~map.isKey(data{i}{3})
        disp('Parseing error!\n');
        return;
    end

    fea = data{i}{1};
    pid = data{i}{2};
    claNo = map(data{i}{3});

    personVideos = personsMats{pid};
    personResponses = personsResponses{pid};

    personVideos = [personVideos; {fea}];
    personResponses = [personResponses; {claNo}];

    personsMats{pid} = personVideos;
    personsResponses{pid} = personResponses;
end

save('personsMats.mat', 'personsMats', '-v7.3');
save('personsResponses.mat', 'personsResponses', '-v7.3');

tot_time = toc(programBegin)/60;
fprintf('extract features total use time: %.0f min\n', tot_time);
if tot_time > 100
    fprintf('That is %.1f hours\n', tot_time/60);
end

end



function [fea, pid, cla] = transSingle(filename)
% fea: features
% pid: person id
% cla: action class name

[~,name,~] = fileparts(filename);
% Indices of the underlines
idx = strfind(name, '_');
pidx = idx(1) - 2;      % Index of the starting of person id
pid = str2num(name(pidx:pidx+1));  % Get person id
cla = name(idx(1)+1 : idx(2)-1);

fea = [];
fid = fopen(filename);
if fid == -1
    disp('Error: Can not open file');
    return;
end

while ~feof(fid)
    line = fgetl(fid);
    pt = str2num(line);
    if ~isempty(pt)
        fea = [fea; pt(245: size(pt,2))];
    end
end

end

