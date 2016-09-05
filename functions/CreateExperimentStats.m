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


function [ resultAsStructuredArray ] = subset(eventSet, beginValue, endValue)

        disp(['Subset [' beginValue ' --> ' endValue ']' ]);

        matches = arrayfun(@(x)... 
        ~isempty(regexp(x.type, beginValue, 'match')) || ...
        ~isempty(regexp(x.type, endValue, 'match')), eventSet);

        if all(matches)
            %error('No matches found maybe the Regex pattern is wrong?');
        end
    
        boundsIdx = find(matches);

        bounds = reshape(boundsIdx, [2, length(boundsIdx) / 2]);
        
        segmentCount = length(bounds/2);

        disp(['Results in ' num2str(segmentCount) ' segments']);

        resultAsStructuredArray = [];

        for bound = bounds

            eventSetForCurrentBounds = eventSet(bound(1):bound(2));

            if isempty(resultAsStructuredArray)
                resultAsStructuredArray.set = eventSetForCurrentBounds;
            else
                resultAsStructuredArray(end+1).set = eventSetForCurrentBounds;
            end;  
        end
end