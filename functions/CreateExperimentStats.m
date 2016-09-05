function output = CreateExperimentStats(EEG, MAZELAB, trialTypes, subject)
%myFun - Description
%
% Syntax: output = myFun(input)
%
% Long description
    
    ms = '\t'; % separator for each marker propertie
    output = ExperimentStatistics(subject);
    
    disp(['Start subsetting per Environment'])
    for maze = MAZELAB.MAZES; 

        disp(['Start subsetting per Trial Type in Maze: ' maze.Name]);
        for trialType = trialTypes;
            %de-reference of the content of the cell
            trialType = trialType{1};
 
            for path = maze.Paths
                
                subsets = subset(EEG.event, ['BeginTrial' ms trialType ms maze.Name ms path.Id ], ['EndTrial' ms trialType ms maze.Name ms path.Id ]);

                trialCount = length(subsets);

                if trialCount == 0
                    disp(['Skip '  trialType ms maze.Name ms path.Id ]);
                    continue;
                end

                disp(['Create Trial Statistic: ' trialType ' ' maze.Name ' Path: ' path.Id ]);

                for ti = 1:trialCount
                    trial = TrialStats(trialType, maze, path.Id, subsets(ti).set); 
                    trial.MazeStats = CreateMazeStats(trial);
                    % append the trial
                    if isempty(output.Trials)
                        output.Trials = trial;
                    else
                        output.Trials(end+1) = trial;
                    end
                end
            end 
        end
    end
    
end