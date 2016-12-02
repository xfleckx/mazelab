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
% EEG = CorrectLatencies(EEG, 0.001); % only for the first pilot data set

%% Import Mazes
% dirContainingMazeFiles = 'testData/*.maze';
% MAZELAB.Import(dirContainingMazeFiles);
% clear dirContainingMazeFiles

%% Plot all imported / available mazes
% MAZELAB.PlotOverview();

%% Plot a single maze
plotter = MazePlotter();
maze = MAZELAB.MAZES(1);
plotter.preparePlot(maze.Matrix).PlotAsImageSc('title', maze.Name);



 %% Create Experiment Statistics
% trialTypesOfInterest = {'Training', 'Experiment'};
% conditionsOfInterest = { 'mobi' }; % pilot data
% experiment = MAZELAB.CreateExperimentStats(EEG, trialTypesOfInterest, ...
%                               conditionsOfInterest, 'pilot_one');

%%
%disp(experiment.summarize());

%% Plot the TICs for the first trial
% Bad example
%MazeStatsPlot(experiment.Trials(1).MazeStats);

statsOfTrial1 = experiment.Trials(1).MazeStats.MazeMatrix;
mazeOfTrial1 = experiment.Trials(1).Maze.Matrix;

plotter = MazePlotter();
plotter.preparePlot(mazeOfTrial1).ApplyData(statsOfTrial1).PlotAsImageSc('title', 'Time In Cell');

%% build a selection function
% selectionFun = @(t) strcmp(t.Maze.Name, 'Maze1') && strcmp(t.Path, '0');
% 
% selectionResult = where(experiment.Trials, selectionFun);
% 
% stats = [ selectionResult.MazeStats ];
% ticsOfAllTrials = { stats.MazeMatrix };
% X = cat(3, ticsOfAllTrials{:});
% avgTicsInThisMaze = mean(X, 3);
% 
% avgPlot = MazePlotter();
% avgPlot.preparePlot(mazeOfTrial1.Matrix).ApplyData(avgTicsInThisMaze).PlotAsImageSc('title', ' AVG Time In Cell');
%% Create Event classes from imported event structure

% first setup all interesting marker pattern and their corresponding envt classes
%
% marker separator
ms = '\t'; % tabulator
turnFromTo = ['Turn' ms 'From\(\d+\s\d+\)' ms 'To\(\d+\s\d+\)'];
%

%% First add specific markers for Condition and Trial names

expectedMarkerPattern(end+1) = MarkerPattern('Begin Condition', 'Begin Cond', 'conditionType', ' \W+\w*\W+ '); 

expectedMarkerPattern(end+1) = MarkerPattern('Begin Trial', 'Begin Cond', 'trialType', 'Trial \W+\w*\W+ '); 
% assuming we want to compare Turns against non-turns
expectedMarkerPattern(end+1) = MarkerPattern([turnFromTo ms 'T' ms 'LEFT'],'T CROSS LEFT TURN');
expectedMarkerPattern(end+1) = MarkerPattern([turnFromTo ms 'T' ms 'RIGHT'],'T CROSS RIGHT TURN');
expectedMarkerPattern(end+1) = MarkerPattern([turnFromTo ms 'I' ms 'STRAIGHT'],'NO TURN');
% don't care about the actual objects... just wan't to look after an ERP
expectedMarkerPattern(end+1) = MarkerPattern('ShowObject|ObjectFound','Object');
% % Create Events for epoching the data set
% EEG = GenerateEventClasses(EEG, expectedMarkerPattern);
% eeg_checkset;
% Export the Events to mobilab
