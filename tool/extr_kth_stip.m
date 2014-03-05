function [] = extr_kth_stip(filename)
% Extract features and responses from a text file which contains many feature informations of interest points, each feature point occupys a line with some specified format.
% This text file is obtained by stip-det tools.
% filename : the text file's full path(including its name). 
%specified format: 
%  point-type y-norm x-norm t-norm y x t sigma2 tau2 dscr-hog(72) dscr-hof(90)

programBegin = tic;

% Person numbers
n = 25;

% Persons matrices and responses
personsMats = cell(1, n);
personsResponses = cell(1, n);
personsCoordinates = cell(1, n);

% Classes
classes = cell(1,6);
classes{1} = 'boxing';
classes{2} = 'handclapping';
classes{3} = 'handwaving';
classes{4} = 'jogging';
classes{5} = 'running';
classes{6} = 'walking';

% Open file
fid = fopen(filename);

% Get the first line
fgetl(fid);

% Fill in the persons matrices
mat = [];
class = 0;
coordinate = [];
while ~feof(fid)
    line = fgetl(fid);
    % Lines with #
    if strfind(line, '#')
        % Fill in the person matrices
        if size(mat,1)
            % Get old
            personVideos = personsMats{personId};
            personResponses = personsResponses{personId};
            personCoordinates = personsCoordinates{personId};
            % Update old to new
            personVideos = [personVideos; {mat}];
            personResponses = [personResponses; {class}];
            personCoordinates = [personCoordinates; {coordinate}];
            % Write new
            personsMats{personId} = personVideos;
            personsResponses{personId} = personResponses;
            personsCoordinates{personId} = personCoordinates;
            % Update mat
            mat = [];
            coordinate = [];
        end
        % Indices of the underlines
        underlineIndices = strfind(line, '_');
        % Index of the starting of person id
        personIdIdx = underlineIndices(1) - 2;
        % Get person id
        personId = str2num(line(personIdIdx:personIdIdx+1));
        % Get class of the video
        class = 0;
        for i=1:size(classes,2)
            if strfind(line, classes{i})
                class = i;
                break;
            end
        end
        if class == 0
            error('Can not find class!');
            return;
        end
    % Lines without #
    else
        feature = str2num(line);
        if ~isempty(feature)
            coordinate = [coordinate;feature(5:7)];
            mat = [mat;feature(10:size(feature,2))];
        end
    end
end

save('personsMats.mat', 'personsMats', '-v7.3');
save('personsResponses.mat', 'personsResponses', '-v7.3');
save('personsCoordinates.mat', 'personsCoordinates', '-v7.3');

% disp(['Extract features total use time: ', datestr(datenum(0,0,0,0,0,toc(programBegin), 'HH:MM:SS')), newLine]);
fprintf('extract features total use time: %f hour\n', toc(programBegin)/3600);

end

