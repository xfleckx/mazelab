classdef MazeModel
    %MAZEMODEL A representation of a MoBI Maze
    %   Instances of this class representing all informations about
    %   a single maze instance from a BeMoBI navigation experiment
    properties
        Name
        %The matrix representing the maze structure
        %   Convention first row points to north
        %   Convention first column points to east
        Matrix
        Paths
    end
    
    methods
    end
    
end