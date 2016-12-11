PrepareExamples

%% Plot all imported / available mazes
 MAZELAB.PlotOverview();

%% Plot a single maze
plotter = MazePlotter();
maze = MAZELAB.MAZES(1);
plotter.preparePlot(maze.Matrix);

plotter.PlotStructure('title', maze.Name);
%figure;
%plotter.PlotAsColormap('title', maze.Name);



%% Create Experiment Statistics
trialTypesOfInterest = {'Training', 'Experiment'};
conditionsOfInterest = { 'mobi' }; % pilot data
experiment = MAZELAB.CreateExperimentStats(EEG, trialTypesOfInterest, ...
                                           conditionsOfInterest, 'pilot_one');

%%
%disp(experiment.summarize());

%% Plot the TICs for the first trial
% Bad example
%MazeStatsPlot(experiment.Trials(1).MazeStats);

statsOfTrial1 = experiment.Trials(1).MazeStats.MazeMatrix;  
mazeOfTrial1 = experiment.Trials(1).Maze.Matrix;
cm = GetCustomColorMap('colorCount', 1000, 'zeroPosition', 'bottom');
plotTitle = 'Aufenthalt in Einheit';
figure;
subplot(1,2,1);
plotter = MazePlotter();
plotter.preparePlot(mazeOfTrial1).ApplyData(statsOfTrial1).PlotAsImageSc('title', plotTitle,'barTitle', 'Sek.', 'colormap', cm);

subplot(1,2,2);
plotter = MazePlotter();
plotter.preparePlot(mazeOfTrial1,'doNotExtrapolate',1).ApplyData(statsOfTrial1,'doNotExtrapolate',1).PlotAsImageSc('title', plotTitle, 'barTitle', 'Sek.', 'colormap', cm);

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

%% First add specific markers for Condition and Trial names

converter = EventConverter();
converter.TrialTypePattern = 'BeginTrial\s+(\w*)';
converter.ConditionTypePattern = 'Begin Condition \W+(\w*)\W+'; 

% marker separator
ms = '\t'; % tabulator
turnFromTo = ['Turn' ms 'From\(\d+\s\d+\)' ms 'To\(\d+\s\d+\)'];

converter.Create([turnFromTo ms 'T' ms 'LEFT'],    'A  T CROSS LEFT TURN');
converter.Create([turnFromTo ms 'T' ms 'RIGHT'],   'B  T CROSS RIGHT TURN');
converter.Create([turnFromTo ms 'I' ms 'STRAIGHT'],'C  NO TURN');

% don't care about the actual objects... just wan't to look after an ERP
converter.Create('ShowObject|ObjectFound','Object');

%% Create Events for epoching the data set
[EEG, conversionResult] = MAZELAB.RenameMarkerToClasses(EEG, converter, 'verbose', 1);
% eeg_checkset;
% Export the Events to mobilab
