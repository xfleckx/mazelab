classdef TrialStats

    properties
        Type
        Condition
        Maze
        Path
        EventSet
        MazeStats
        Turns
    end
    methods 
        function obj = TrialStats(type, condition, maze, path, eventSet)
            obj.Type = type;
            obj.Condition = condition;
            obj.Maze = maze;
            obj.Path = path;
            obj.EventSet = eventSet;
            obj.Turns = [];
        end

        function duration = getDuration(obj)
            duration = obj.EventSet(end).latency - obj.EventSet(1).latency;
        end
        
    end
end