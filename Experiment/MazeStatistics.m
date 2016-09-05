classdef MazeStatistics
    properties 
        MazeModel
        MazeMatrix
    end

    methods
        function obj = MazeStatistics(mazeModel)
            obj.MazeModel = mazeModel; 
        end
    end
end