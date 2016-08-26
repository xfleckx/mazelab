function [ EEG ] = CreateEpochs( EEG, MAZELAB )

    EEGLabExt.Check(EEG, 'ignoreUrevents');

    MazeLab.Check(MAZELAB);

    trialTypes = { 'Training', 'Experiment' };
    nTrialTypes = length(trialTypes);

    mazes = MAZELAB.Mazes;
    nmazes = length(mazes);

    for mazeIndex = 1 : nmazes
        maze = mazes(mazeIndex);
        paths = maze.Paths;
        npaths = length(paths);
        
        for pathIndex = 1 : npaths
            path = paths(i);

            for trialTypeIndex : nTrialTypes
                
                startEvent = ['BeginTrial' '\t' trialTypes{trialTypeIndex} '\t' maze.Name '\' path.Id ]

                endEvent = ['EndTrial' '\t' trialTypes{trialTypeIndex} '\t' maze.Name '\' path.Id ]

                eeg_context(EEG, { startEvent } , { endEvent }, 1)

            end;
        end;

    end;

end;