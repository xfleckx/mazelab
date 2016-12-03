%%
summary = experiment.summarize();
allMazes = summary.environments;
countOfEnvironments = numel(allMazes);

%%
analyseResults = [];
% for all mazes
for i_e = 1:countOfEnvironments
   currentMaze = allMazes(i_e);
   sf = @(t) strcmp(t.Maze.Name, currentMaze);
   trialsOfCurrentMaze = where(experiment.Trials, sf);
   
   % for all paths
   paths = unique({trialsOfCurrentMaze.Path});
   
   countOfPaths = numel(paths);
   
   for i_p = 1:countOfPaths
       currentPath = paths(i_p);
       
%select all trials of training
       sf =  @(t) strcmp(t.Path, currentPath) && strcmp(t.Type, 'Training');
       trainingTrials = where(trialsOfCurrentMaze, sf);
% avg training
       statsTraining = [trainingTrials.MazeStats];
       avg_training = mean(cat(3, statsTraining.MazeMatrix),3);
       
%select all trials of experiment
       sf =  @(t) strcmp(t.Path, currentPath) && strcmp(t.Type, 'Experiment');
       experimentTrials = where(trialsOfCurrentMaze, sf);
% avg experiment
       statsExperiment = [experimentTrials.MazeStats];
       avg_Experiment = mean(cat(3, statsExperiment.MazeMatrix),3);
       
       analyseResults(end+1).Maze = currentMaze;
       analyseResults(end).Path = currentPath;
       analyseResults(end).Training = avg_training;
       analyseResults(end).Experiment = avg_Experiment;
       analyseResults(end).Delta = abs(avg_training - avg_Experiment);
   end
   
end

%% Plot the differences
plotter = MazePlotter();

for i_r = numel(analyseResults)
    
subplot(countOfEnvironments, countOfPaths, ir);

end


