%% start EEGLAB
eeglab
addpath('testData');

%% Load xdf dataset
dirContainingXDFfiles = 'testData/*.xdf';
xdfFiles = dir(dirContainingXDFfiles);
%
for f = xdfFiles
  [EEG] =  pop_loadxdf(f.name);
  ALLEEG = [ALLEEG EEG];
end;
clear xdfFiles dirContainingXDFfiles f

%% Corrections - just for the pilot dataset
EEG = CorrectLatencies(EEG, 0.001); % only for the first pilot data set

%% Import Mazes
dirContainingMazeFiles = 'testData/*.maze';
MAZELAB.Import(dirContainingMazeFiles);
clear dirContainingMazeFiles
