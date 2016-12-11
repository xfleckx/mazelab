classdef MazeImporter
    %MAZEIMPORTER Import .maze files to MazeModels used by MAZELAB
    %   Detailed explanation goes here
    
    properties
    end
    
    properties (Constant)
        DefaultMatrixPattern = 'Maze:\s*([\w|\d]*)\s*matlab matrix:\s*(\[(\s\w*|\s*[,|;]+\s*)+ \])+';
        DefaultPathPattern = 'Path:\s*([\w|\d]*)\s*matlab path matrix:\s*(\[(\s\w*|\s*[,|;]+\s*)+ \])+';
    end
    
    methods
    end
    
end

