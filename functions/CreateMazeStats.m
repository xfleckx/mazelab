function mazeStats = CreateMazeStats( trialStats )
    
    if ~isa(trialStats,'TrialStats')
        error('Input variable trialStats should be an object of class "TrialStats"');
    end

    mazeStats = MazeStatistics();

end