function output = CreateExperimentStats(EEG, MAZELAB, trialTypes, conditions, subject, varargin)
%myFun - Description
%
% Syntax: output = myFun(input)
%
% Long description

p = inputParser;
% TODO verify all inputs
defaultLatencyCorrection = 1;
addOptional(p, 'latencyCorrection', defaultLatencyCorrection, @isnumeric);

parse(p, varargin{:});

latencyCorrection = p.Results.latencyCorrection;

ms = '\t'; % separator for each marker propertie
output = ExperimentStatistics(subject);

for condition = conditions

    condition = condition{1};

    disp('Start subsetting per Condition');

    subsetPerCondition = subset(EEG.event,...
     ['Begin\s+Condition\s+\W+' condition '\W+'],...
     ['End\s+Condition\s+\W+' condition '\W+']); 

     if isempty(MAZELAB.MAZES)
        error('MAZELAB doesnt know any environments. Import them first!');
     end
     
     disp('Start subsetting per Environment')
    for maze = MAZELAB.MAZES; 

        disp(['Start subsetting per Trial Type in Maze: ' maze.Name]);
        for trialType = trialTypes;
            %de-reference of the content of the cell
            trialType = trialType{1};

            for path = maze.Paths

                subsets = subset(subsetPerCondition{1},...
                 ['BeginTrial' ms trialType ms maze.Name ms path.Id ],...
                 ['EndTrial' ms trialType ms maze.Name ms path.Id ],'ignoreEmpty',1);

                 if isempty(subsets)
                    continue;
                 end

                trialCount = length(subsets);

                if trialCount == 0
                    fprintf(['Skip '  trialType ms maze.Name ms path.Id '\n'])
                    continue;
                end

                disp(['Create Trial Statistic: ' trialType ' ' maze.Name ' Path: ' path.Id ]);

                for ti = 1:trialCount

                    trial = TrialStats(trialType, condition, maze, path.Id, subsets{ti}); 

                    trial.MazeStats = CreateMazeStats(trial);

                    turnSegments = contextSubset(trial.EventSet, 'Entering\s+Unit', 'Turn\s+From', 'contextOp', 'adjacent');
                    turnCount = length(turnSegments);

                    for idx = 1:turnCount

                        marker = turnSegments(idx).set;

                        beginTurn = marker(1);

                        endTurn = marker(end);
                        
                        delta = (endTurn.latency - beginTurn.latency);
                        
                        turn.Duration = delta * latencyCorrection;

                        marker = marker(end);

                        [match, token] = regexp(marker.type,'\s+[ILTX]+\s+(\w+)', 'match', 'tokens');
                        turn.Type = token{1}{1};

                        [match, token] = regexp(marker.type,'From\((\d+\s+)(\s?\d+)\)\s+To\((\d+\s+)(\s?\d+)\)','match','tokens');

                        % Matlab starts counting at 1, Maze export first
                        % row/colum as 0 so increment all by one!
                        turn.From = [ str2num(token{1}{1})+1 str2num(token{1}{2})+1 ];
                        turn.To = [ str2num(token{1}{3})+1 str2num(token{1}{4})+1 ];

                        [match, token] = regexp(marker.type,'\s+([ILTX])+\s+\w+', 'match', 'tokens');
                        turn.UnitType = token{1}{1}; % dereference the cell value

                        if isempty(trial.Turns)
                            trial.Turns = turn;
                        end

                        trial.Turns(idx) = turn;
                    end

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

    
    
end