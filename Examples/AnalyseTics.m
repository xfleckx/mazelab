function [ res ] = AnalyseTics( experiment )
%ANALYSETICS Summary of this function goes here
%   Detailed explanation goes here
%%
summary = experiment.summarize();
allMazes = summary.environments;

%%
res.resultPerMaze = [];
res.countOfEnvironments = numel(allMazes);
% for all mazes
for i_e = 1:res.countOfEnvironments
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
       
       %delta = abs(avg_training - avg_Experiment);
       delta = avg_training - avg_Experiment;
       % positiv -> im Training länger in der unit gewesen
       % negativ -> im Experiment länger in der Unit gewesen
       % = delta(delta > 0);
       
       res.resultPerMaze(end+1).Maze = currentMaze;
       res.resultPerMaze(end).Path = currentPath;
       res.resultPerMaze(end).Training = avg_training;
       res.resultPerMaze(end).Experiment = avg_Experiment;
       res.resultPerMaze(end).Delta = delta;
       res.resultPerMaze(end).deltaMin = min(delta);
       res.resultPerMaze(end).deltaMax = max(delta);
       
       % res.resultPerMaze(end).deltaMin = min(allValuesExceptZero(:));
       % res.resultPerMaze(end).deltaMax = max(allValuesExceptZero(:));
   end
   
   allMins = [res.resultPerMaze.deltaMin];
   allMax = [res.resultPerMaze.deltaMax];
   
   res.deltaMin = min(allMins(:));
   res.deltaMax = max(allMax(:));
end

end

