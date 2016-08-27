%% set some parameters
dirContainingMazeFiles = 'testData/MazeModels';
dirContainingXDFfiles = '';
%% start EEGLAB
eeglab
%% Load xdf dataset

xdfFiles = dir(dirContainingXDFfiles);

for file = xdfFiles

end;


%% Import Mazes

mazeFiles = dir(dirContainingMazeFiles);

for file = mazeFiles
    MAZELAB.LASTIMPORT = load_maze(file);
    MAZELAB.MAZES = [ MAZELAB.MAZES MAZELAB.LASTIMPORT ] ;
end;

%% Create Event classes from imported event structure

% first setup all interesting marker pattern and their corresponding envt classes 

%marker separator 
ms = '\t'; % tabulator
turnFromTo = ['Turn' ms 'From\(\d+\s\d+\)' ms 'To\(\d+\s\d+\)'];

% assuming we want to compare Turns against non-turns
expectedMarkerPattern = MarkerPattern([turnFromTo ms 'T' ms 'LEFT'],'T CROSS LEFT TURN'); 
expectedMarkerPattern(end+1) = MarkerPattern([turnFromTo ms 'T' ms 'RIGHT'],'T CROSS RIGHT TURN');
expectedMarkerPattern(end+1) = MarkerPattern([turnFromTo ms 'I' ms 'STRAIGHT'],'NO TURN');
% don't care about the actual objects... just wan't to look after an ERP
expectedMarkerPattern(end+1) = MarkerPattern('ShowObject|ObjectFound','Object');
% Create Events for epoching the data set
EEG = GenerateEventClasses(EEG, expectedMarkerPattern);
% Export the Events to mobilab
