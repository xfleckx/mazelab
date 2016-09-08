classdef MazeModel < handle
    %MAZEMODEL A representation of a MoBI Maze
    %   Instances of this class representing all informations about
    %   a single maze instance from a BeMoBI navigation experiment
    properties
        Name
        SourceFile
        %The matrix representing the maze structure
        %   Convention first row points to north
        %   Convention first column points to east
        Matrix
        Paths
        Stats
    end
    
    properties  (Access = private)
        heatMap
    end

    methods
        function PlotStructure(obj)
            dimension = size(obj.Matrix);
            cols = dimension(1);
            rows = dimension(2);
            
            % 
            %kron(maze.Matrix,ones(2,2))

            xgv = linspace(0, cols, cols);
            ygv = linspace(0, rows, rows);

            [X,Y] = meshgrid(xgv, ygv);

            % Z = kron(obj.Matrix,ones(2,2));

            % figure;
            % title(['Maze: ' obj.Name]);
            % %set(get(gca, 'Title'), 'String', obj.Name);
            % %mesh(X,Y);
            % surf(X,Y,Z);
        end;
        
        function PlotAsHeatMap(obj)
            obj.heatMap = HeatMap(obj.Matrix);
        end;

        function Plot(obj)
            
        end;
    end
    
end