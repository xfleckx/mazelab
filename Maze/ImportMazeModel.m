function mazeModel = ImportMazeModel( filename )
    % ImportMazeModel expect a file containing the representation of a
    % Maze as binary matrix
    p = inputParser();
    addRequired(p,'filename',@ischar);
    parse(p,filename)
    if ~exist(filename, 'file')
            throw(MException('ImportMazeModel:FileNotFound', filename ));
    end
    
    
    [~,name,~] = fileparts(filename);
    
    mazeModel = MazeModel();
    mazeModel.Name = name;
    
    mazeMatrixPattern = 'matlab matrix:';
    pathLinePattern = 'Path: ';
    pathMatrixPattern = 'matlab path matrix:';
    
    Paths = [];
    
    fid = fopen( filename ); % open the file
    while ~feof(fid) % loop over the following until the end of the file is reached.
          line = fgets(fid); % read in one line
          
          if strfind(line, mazeMatrixPattern) % if that line contains 'p', set the first index to 1
              startOfMatrixString = strfind(line, mazeMatrixPattern) + length(mazeMatrixPattern);
              endOfMatrixString = length(line);
              mazeMatrixAsString = line(startOfMatrixString : endOfMatrixString);
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
                newPath.Matrix = eval(PathMatrixAsString);
                mazeModel.Paths = [mazeModel.Paths newPath];
                
              end
              
          end
    end
    fclose(fid);
    
    mazeModel.Matrix = eval(mazeMatrixAsString);
    
    
end