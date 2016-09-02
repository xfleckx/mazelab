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
    
    mazeModel = MazeModel();
    mazeModel.Name = name;
    
    mazeMatrixPattern = 'matlab matrix:';
    pathLinePattern = 'Path: ';
    pathMatrixPattern = 'matlab path matrix:';
    
    Paths = [];
    
    disp(['Importing Maze: ' mazeModel.Name ' from file: ' name ' at location: ' path]);
    
    fid = fopen( filename ); % open the file
    while ~feof(fid) % loop over the following until the end of the file is reached.
          line = fgets(fid); % read in one line
          
          disp(['Read line: "' line '"']);

          if strfind(line, mazeMatrixPattern) % if that line contains 'p', set the first index to 1
              startOfMatrixString = strfind(line, mazeMatrixPattern) + length(mazeMatrixPattern);
              endOfMatrixString = length(line);
              mazeMatrixAsString = line(startOfMatrixString : endOfMatrixString);
              
              disp(['Try to evaluate Maze matrix: ' mazeMatrixAsString ]);
              
              resultOfEval =  eval( mazeMatrixAsString );
              clear mazeMatrixAsString
              mazeModel.Matrix = resultOfEval;
              continue;
          end
          
          
          if strfind(line, pathLinePattern) 
              
              if strfind(line, pathMatrixPattern)
                  
                startOfMatrixPattern = strfind(line, pathMatrixPattern);
                
                startOfMatrixString = startOfMatrixPattern + length(pathMatrixPattern);
                
                endOfMatrixString = length(line);
                
                PathMatrixAsString = line(startOfMatrixString : endOfMatrixString);    
                
                startIndexOfPathID = length(pathLinePattern);
                endIndexOfPathID = startOfMatrixPattern;
                
                pathID = line(startIndexOfPathID : endIndexOfPathID);
                newPath = PathModel();
                newPath.Id = pathID;
                newPath.RefMazeName = mazeModel.Name;
                
                disp(['Try to evaluate Path matrix: ' PathMatrixAsString ]);
                
                resultOfEval = eval(PathMatrixAsString);
                clear PathMatrixAsString
                newPath.Matrix = resultOfEval;
                
                mazeModel.Paths = [mazeModel.Paths newPath];
                
              end
              
          end
    end
    fclose(fid);
    
    
    disp(['Finished import of Maze: ' mazeModel.Name ]);
    
end