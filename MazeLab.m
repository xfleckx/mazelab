classdef MazeLab < handle
  properties
      MAZES
      LASTIMPORT
   end
   
   methods(Static)
     function MAZELAB = getInstance
     % function: Get a singleton representing MazeLab application
     %
          persistent localObj

          if isempty(localObj) || ~isvalid(localObj)
             localObj = MazeLab();
          end

          MAZELAB = localObj;
     end  % function
    end

  methods (Access = private)

    function obj = MazeLab()

    end

  end

  methods(Access = public)
    function Import (obj, sourceDir , varargin )
    % function: Import environmental data into MAZELAB
    %
    % Extended description
    p = inputParser;

    validateSourceDir = @(x) ischar(x) && isstruct(dir(sourceDir));
    addRequired(p, 'sourceDir', validateSourceDir);

    parse(p, sourceDir, varargin{:});

    mazeFiles = dir(p.Results.sourceDir);

    for f = 1:length(mazeFiles)
        obj.LASTIMPORT = load_maze(mazeFiles(f).name);
        obj.MAZES = [ obj.MAZES obj.LASTIMPORT ] ;
    end

    end  % function

  end
end
