classdef MazeLab
   methods(Static)
      function result = Check( MAZELAB )
          if ~isstruct(MAZELAB)
            error([inputname(MAZELAB) ' argument must be an MAZELAB dataset structure']);
          end

          if ~isfield(MAZELAB, 'MAZES')
              error('MAZELAB parameter should contain the MAZES field');
          end

          result = 1;
      end

      function MAZELAB = Import ( sourceDir , MAZELAB, varargin )
      % function: Short description
      %
      % Extended description
      p = inputParser;

      validateSourceDir = @(x) ischar(x) && isstruct(dir(sourceDir));
      addRequired(p, 'sourceDir', validateSourceDir);

      addRequired(p, 'MAZELAB', @MazeLab.Check)

      parse(p, sourceDir, MAZELAB, varargin{:});

      mazeFiles = dir(p.Results.sourceDir);

      MAZELAB = p.Results.MAZELAB;

      for f = 1:length(mazeFiles)
          MAZELAB.LASTIMPORT = load_maze(mazeFiles(f).name);
          MAZELAB.MAZES = [ MAZELAB.MAZES MAZELAB.LASTIMPORT ] ;
      end

      end  % function

    end
end
