classdef PathModel
    %PATHMODEL Represents the Model of a Path which belongs to a specific
    %maze
    %   Detailed explanation goes here
    
    properties (SetAccess = public)
        RefMazeName
        Id
        Matrix
    end
       
    properties (SetAccess = private)
        heatMap
    end
    methods
        function PlotAsHeatMap(obj, mazeMatrix)
            pathMatrix = mazeMatrix + obj.Matrix;
            obj.heatMap = HeatMap(pathMatrix);
        end;
    end
    
end

