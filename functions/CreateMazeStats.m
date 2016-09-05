function mazeStats = CreateMazeStats( trialStats )
    
    if ~isa(trialStats,'TrialStats')
        error('Input variable trialStats should be an object of class "TrialStats"');
    end

    mazeStats = MazeStatistics(trialStats.Maze);
    mazeStats.MazeMatrix = trialStats.Maze.Matrix;

    unitSegments = subset(trialStats.EventSet, 'Entering Unit', 'Exiting Unit');
    countOfUnits = length(unitSegments);
    
    for idx = 1:countOfUnits
        
        markerSet = unitSegments(idx).set;

        firstMarkerInSet = markerSet(1);
        lastMarkerInSet = markerSet(end);
        [match, tokens] = regexp(firstMarkerInSet.type, 'Unit\s+\((\d+)\s+(\d+)\)', 'match', 'tokens');
        
        if isempty(match)
            error('Pattern for extracting Unit position from Marker might be wrong!');
        end
        
        col = str2num(tokens{1}{1}) + 1; % Indexing stars at 1 correction!
        row = str2num(tokens{1}{2}) + 1; % Indexing stars at 1 correction!
% ich muss hier wieder die Addressierung umkehren um vom Anfange bei 0,0 zu beginnen... Matlab Maze ist dummerweise wieder links oben die 0,0
        timeInCell = lastMarkerInSet.latency - firstMarkerInSet.latency;
        unitValue = mazeStats.MazeMatrix(row,col);

        if isempty(unitValue)
            error(['Try to access empty unit at address at Col ' num2str(col) ' Row ' num2str(row)]);
        end

        mazeStats.MazeMatrix(row,col) = unitValue * timeInCell;
    end
end