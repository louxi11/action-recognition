function [] = getBestResult()

%=========================================================
centers = [10:10:100 200:100:1000 2000:1000:6000];
para.dataPath = '/home/wangxz/dataset/kth/ExtractedFeatures/hoghof';
para.isSaveLog = 1;     % 0 - not save, 1 - save
para.logFilename = 'harris_hof_vlad_2014-2-25.log';
para.figFilename = 'harris_hof_vlad_2014-2-25.fig';
para.isLoadCenter = 1;  % 0 - compute directly, 1 - load only
para.isSaveCenter = 0;  % 0 - not save, 1 - save
para.centerDir = 'centers_hof';
%=========================================================

programBegin = tic;

if para.isSaveLog
    diary(para.logFilename);
end

fprintf('\n==================Begin=====================\n');
fprintf('\nProgram Description:\n');
fprintf('   harris + hof + vlad + l-svm\n');
fprintf('   dataPath : %s\n', para.dataPath);
fprintf('   centerDir: %s\n', para.centerDir);
fprintf('   log name : %s\n', para.logFilename);
fprintf('   fig name : %s\n', para.figFilename);
if para.isLoadCenter
    fprintf('   using pretrained centers\n\n');
else
    fprintf('   training centers directly\n\n');
end


addToolPath();

acc = framework(centers, para);

% Plot result
fig = figure;
plot(centers, acc);
xlabel('#center');
ylabel('accuracy');
title('KTH accuracy varies with dictionary size');
if para.isSaveLog
   saveas(fig, para.figFilename);
end
 
disp(['Figure Information:', 10]);
disp('   Center numbers:');  
disp(centers); disp(['' 10]);
disp('   Accuracies:');  
disp(acc);


totalTime = toc(programBegin);
fprintf('program total runs %.0f s', totalTime);
if totalTime > 100 
    fprintf('(about %.0f min)', totalTime/60);
end
fprintf('\n===================End======================\n');

if para.isSaveLog
     diary off
end

removeToolPath();

end
