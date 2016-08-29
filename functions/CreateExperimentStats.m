function output = CreateExperimentStats(EEG, MAZELAB, trialTypes, subject)
%myFun - Description
%
% Syntax: output = myFun(input)
%
% Long description
    
    ms = '\t';
    output = ExperimentStatistics(subject);

    for maze = MAZELAB.MAZES;

        %slice the data set the each maze
        [ subsetsAsArray, ~ ] = subset(EEG.event, ['Begin Trial' '\t' strjoin(TrialTypes,'|') '\t' maze.Name ], ['End Trial' '\t' maze.Name ]);
        
        for trialType = trialTypes;
            %dereference of the content of the cell
            trialType = trialType{1};

            [ subsetsAsArray, subsetsAsStructArray ] = subset(subsetsAsArray, ['BeginTrial' '\t' trialType ], ['EndTrial' '\t' trialType ]);
            
            for setOfATrial = subsetsAsStructArray
              
                trial = TrialStats(trialType, maze, 'test', setOfATrial.set); 
                
                % append the trial
                if isempty(output.Trials)
                    output.Trials = trial;
                else
                    output.Trials(end+1) = trial;
                end;
            end;
        end
    end
    
end


function [ resultAsArray, resultAsStructuredArray ]= subset(eventSet, beginValue, endValue)

        matches = arrayfun(@(x)~isempty(regexp(x.type, beginValue, 'match')) || ~isempty(regexp(x.type, endValue, 'match')), eventSet);

        boundsIdx = find(matches);

        bounds = reshape(boundsIdx, [2, length(boundsIdx) / 2]);
        
        resultAsStructuredArray = [];
        resultAsArray = [];

        for bound = bounds

            if isempty(result)
                resultAsStructuredArray.set = eventSet(bound(1):bound(2));
            else
                resultAsStructuredArray(end+1).set = eventSet(bound(1):bound(2));
            end;
            
            resultAsArray = [resultAsArray result];

        end
end