function mazeStats = CreateMazeStats( trialStats )

    if ~isa(trialStats,'TrialStats')
        error('Input variable trialStats should be an object of class "TrialStats"');
    end

    mazeStats = MazeStatistics(trialStats.Maze, trialStats.Path);
    mazeStats.MazeMatrix = trialStats.Maze.Matrix;

    unitSegments = subset(trialStats.EventSet, 'Entering Unit', 'Exiting Unit');
    countOfUnits = length(unitSegments);

    allTics = [];

    for idx = 1:countOfUnits

        markerSet = unitSegments{idx};

        firstMarkerInSet = markerSet(1);
        lastMarkerInSet = markerSet(end);
        [match, tokens] = regexp(firstMarkerInSet.type, 'Unit\s+\((\d+)\s+(\d+)\)', 'match', 'tokens');

        if isempty(match)
            error('Pattern for extracting Unit position from Marker might be wrong!');
        end

        sizeOfMazeMatrix = size(mazeStats.MazeMatrix);

        colAsChar = tokens{1}{1};
        rowAsChar = tokens{1}{2};

        col = str2num(colAsChar) + 1; % Indexing stars at 1 correction!
        row = str2num(rowAsChar) + 1; % Indexing stars at 1 correction!

        %to start on the lower left corner!
        row = sizeOfMazeMatrix(1) + 1 - row;

        unitValue = mazeStats.MazeMatrix(row, col);
        timeInCell = lastMarkerInSet.latency - firstMarkerInSet.latency;

        if isempty(unitValue)
            error(['Try to access empty unit at address at Col ' num2str(col) ' Row ' num2str(row)]);
        end

        mazeStats.MazeMatrix(row,col) = unitValue * timeInCell;

        allTics = [allTics timeInCell];
    end

    mazeStats.Tics.All = allTics;
    mazeStats.Tics.AvgTic = mean(allTics);
    mazeStats.Tics.Std = std(allTics);

end
