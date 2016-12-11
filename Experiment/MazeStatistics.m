classdef MazeStatistics
%% A Container for data about a maze
%  intendet to be used per trial instance
    properties
        %reference to the imported model of the maze
        MazeModel
        MazeMatrix
        Path
        % A container for a struct providing:
        % obj.Tics.All = tics; % from one Trial
        % obj.Tics.AvgTic = mean(tics);
        % obj.Tics.Std = std(allTics);
        % it represents the timing informations Time in Cell aka Unit
        Tics
    end

    methods
        function obj = MazeStatistics(mazeModel, path)
            obj.MazeModel = mazeModel;
            obj.Path = path;
        end
    end
end
