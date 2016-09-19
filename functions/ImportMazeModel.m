function mazeModel = ImportMazeModel( filename )
    % ImportMazeModel expect a file containing the representation of a
    % Maze as binary matrix
    p = inputParser();
    addRequired(p,'filename',@ischar);
    parse(p,filename)
    if ~exist(filename, 'file')
            throw(MException('ImportMazeModel:FileNotFound', filename ));
    end
    
    [path,name,~] = fileparts(filename);

    fileContent = fileread(filename);

    mazeModel = MazeModel();
    mazeModel.SourceFile = name;
    
    mazeMatrixPattern = 'Maze:\s*([\w|\d]*)\s*matlab matrix:\s*(\[(\s\w*|\s*[,|;]+\s*)+ \])+';

    pathLinePattern = 'Path:\s*([\w|\d]*)\s*matlab path matrix:\s*(\[(\s\w*|\s*[,|;]+\s*)+ \])+';
    
    Paths = [];
    
    disp(['Importing Maze: ' mazeModel.Name ' from file: ' name ' at location: ' path]);
    
    
    [match, groups] = regexp(fileContent, mazeMatrixPattern, 'match', 'tokens');

    mazeId = groups{1}{1};
    mazeModel.Name = mazeId;
    mazeMatrixAsString = groups{1}{2}; 

    disp(['Try to evaluate Maze matrix: ' mazeMatrixAsString ]);
    
    resultOfEval =  eval( mazeMatrixAsString );
    clear mazeMatrixAsString
    mazeModel.Matrix = resultOfEval; % reverse the row order to get the original Maze Pattern!?
    
    [match, groups] = regexp(fileContent, pathLinePattern, 'match', 'tokens');

    for i = 1 : length(groups)
        newPath = PathModel();
        newPath.Id = groups{i}{1};
        newPath.RefMazeName = mazeModel.Name;
        pathMatrixAsString = groups{i}{2}; 

        disp(['Try to evaluate Path matrix: ' pathMatrixAsString ]);

        resultOfEval = eval(pathMatrixAsString);
        clear PathMatrixAsString
        newPath.Matrix = resultOfEval;

        mazeModel.Paths = [mazeModel.Paths newPath];
    end 
    disp(['Finished import of Maze: ' mazeModel.Name ]);
    
end