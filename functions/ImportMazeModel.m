function mazeModel = ImportMazeModel( filename )
    % ImportMazeModel expect a file containing the representation of a
    % Maze as binary matrix
    % mazeModel = ImportMazeModel(aFileName) try to read a .maze file
    % mazeModel = ImportMazeModel(aFileName, 'verbose', 1) print detailed logs

    p = inputParser();
    addRequired(p,'filename',@ischar);
    addOptional(p,'verbose', 0);

    parse(p,filename);
    verbose = p.Results.verbose;

    if ~exist(filename, 'file')
            throw(MException('ImportMazeModel:FileNotFound', filename ));
    end
    
    [pathstr,name,~] = fileparts(filename);

    fileContent = fileread(filename);

    mazeModel = MazeModel();
    mazeModel.SourceFile = name; 

    Paths = [];
    
    if verbose
    disp(['Importing Maze: ' mazeModel.Name ' from file: ' name ' at location: ' pathstr]);
    end;
    
    [match, groups] = regexp(fileContent, MazeImporter.DefaultMatrixPattern, 'match', 'tokens');

    mazeId = groups{1}{1};
    mazeModel.Name = mazeId;
    mazeMatrixAsString = groups{1}{2}; 

    if verbose
    disp(['Try to evaluate Maze matrix: ' mazeMatrixAsString ]);
    end;

    resultOfEval =  eval( mazeMatrixAsString );
    clear mazeMatrixAsString
    mazeModel.Matrix = resultOfEval; % reverse the row order to get the original Maze Pattern!?
    
    [match, groups] = regexp(fileContent, MazeImporter.DefaultPathPattern, 'match', 'tokens');

    for i = 1 : length(groups)
        newPath = PathModel();
        newPath.Id = groups{i}{1};
        newPath.RefMazeName = mazeModel.Name;
        pathMatrixAsString = groups{i}{2}; 

        if verbose
        disp(['Try to evaluate Path matrix: ' pathMatrixAsString ]);
        end

        resultOfEval = eval(pathMatrixAsString);
        clear PathMatrixAsString
        newPath.Matrix = resultOfEval;

        mazeModel.Paths = [mazeModel.Paths newPath];
    end 
    disp(['Finished import of Maze: ' mazeModel.Name ]);
    
end