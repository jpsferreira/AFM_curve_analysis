function save_data(cpwd,name)

% First create the folder B, if necessary.
fname=strcat(name,'_');
outputFolder = fullfile(cpwd, name);
if ~exist(outputFolder, 'dir')
  mkdir(outputFolder);
end
% Copy the files over with a new name.
cd data/
inputFiles = dir( fullfile('*.mat') );
fileNames = { inputFiles.name };
for k = 1 : length(inputFiles )
  thisFileName = fileNames{k};
  % Prepare the input filename.
  inputFullFileName = fullfile(pwd, thisFileName);
  % Prepare the output filename.
  outputBaseFileName = sprintf(strcat(fname,'%s.mat'), thisFileName(1:end-4));
  outputFullFileName = fullfile(outputFolder, outputBaseFileName);
  % Do the copying and renaming all at once.
  copyfile(inputFullFileName, outputFullFileName);
end

cd ..