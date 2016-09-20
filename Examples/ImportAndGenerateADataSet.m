%% start EEGLAB
% eeglab

%% set some parameters
%   dirContainingXDFfiles = 'testData/*.xdf';
%   dirContainingMazeFiles = 'testData/*.maze';

%% Load xdf dataset
% xdfFiles = dir(dirContainingXDFfiles);
%
% for f = xdfFiles
%   [EEG] =  pop_loadxdf(f.name);
%   ALLEEG = [ALLEEG EEG];
% end;
% clear xdfFiles dirContainingXDFfiles f

%% Import Mazes
% mazeFiles = dir(dirContainingMazeFiles);
%
% for f = 1:length(mazeFiles)
%     MAZELAB.LASTIMPORT = load_maze(mazeFiles(f).name);
%     MAZELAB.MAZES = [ MAZELAB.MAZES MAZELAB.LASTIMPORT ] ;
% end;
% clear mazeFiles dirContainingMazeFiles f
%

% EEG = CorrectLatencies(EEG, 0.001); % only for the first pilot data set

 %% Create Experiment Statistics
trialTypesOfInterest = {'Training', 'Experiment'};
conditionsOfInterest = { 'mobi' }; % pilot data
experiment = CreateExperimentStats(EEG, MAZELAB, trialTypesOfInterest, ...
                              conditionsOfInterest, 'pilot_one');

%% Create Event classes from imported event structure

% first setup all interesting marker pattern and their corresponding envt classes
%
% marker separator
% ms = '\t'; % tabulator
% turnFromTo = ['Turn' ms 'From\(\d+\s\d+\)' ms 'To\(\d+\s\d+\)'];
%
% assuming we want to compare Turns against non-turns
% expectedMarkerPattern = MarkerPattern([turnFromTo ms 'T' ms 'LEFT'],'T CROSS LEFT TURN');
% expectedMarkerPattern(end+1) = MarkerPattern([turnFromTo ms 'T' ms 'RIGHT'],'T CROSS RIGHT TURN');
% expectedMarkerPattern(end+1) = MarkerPattern([turnFromTo ms 'I' ms 'STRAIGHT'],'NO TURN');
% don't care about the actual objects... just wan't to look after an ERP
% expectedMarkerPattern(end+1) = MarkerPattern('ShowObject|ObjectFound','Object');
% % Create Events for epoching the data set
%EEG = GenerateEventClasses(EEG, expectedMarkerPattern);
% Export the Events to mobilab
