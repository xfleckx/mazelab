classdef TrialStats

    properties
        Type
        Maze
        Path
        EventSet
        MazeStats
        Turns
    end
    methods 
        function obj = TrialStats(type, maze, path, eventSet)
            obj.Type = type;
            obj.Maze = maze;
            obj.Path = path;
            obj.EventSet = eventSet;
            obj.Turns = [];
        end
    end
end