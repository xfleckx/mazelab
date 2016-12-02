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
    % IMPORT: Import environmental data into MAZELAB
    %
    % Expects a directory containing '.maze' files

    p = inputParser;

    validateSourceDir = @(x) ischar(x) && isstruct(dir(sourceDir));
    addRequired(p, 'sourceDir', validateSourceDir);

    parse(p, sourceDir, varargin{:});

    mazeFiles = dir(p.Results.sourceDir);

        for f = 1:length(mazeFiles)
            obj.LASTIMPORT = load_maze(mazeFiles(f).name);
            obj.MAZES = [ obj.MAZES obj.LASTIMPORT ] ;
        end

    end
    
    function experiment = CreateExperimentStats(obj, EEG, trialTypes, conditions, subject, varargin)
       p = inputParser;
       valEvents = @(x) isfield(x,'event') && ~isempty(x.event);
       addRequired(p, 'EEG', valEvents);
       addRequired(p, 'trialTypes', @iscell);
       addRequired(p, 'conditions', @iscell);
       addRequired(p, 'subject', @ischar);
       addOptional(p, 'useUrEvents', false);

       parse(p, EEG, trialTypes, conditions, subject, varargin{:});
       useUrEvents = p.Results.useUrEvents;

       experiment = BuildExperiment(EEG, obj, trialTypes, conditions, subject, 'useUrEvents', useUrEvents);
    end
    
    function ClearMazeCache(obj)
    % ClearMazeCache  Shortcut to remove all imported mazes.
    %   If you want to reimport a set of mazes use this methode before!
       obj.MAZES = [];
       obj.LASTIMPORT = {};
    end
    
    function fig = PlotOverview(obj,varargin)

        p = inputParser;
        addOptional(p,'all',1);
        parse(p, varargin{:});

        mazesCount = numel(obj.MAZES);
        
        % get a grid
        cols = ceil(sqrt(mazesCount));
        rows = ceil(mazesCount / cols);

        fig = figure('Name','Mazes available','NumberTitle','off');
        
        plotter = MazePlotter();

        for i = 1:mazesCount
            subplot(rows, cols, i);
            maze = obj.MAZES(i);
            plotter.preparePlot(maze.Matrix)...
            .PlotAsImageSc('title', maze.Name, 'mazeOnly', 1, 'noFigure', 1);
        end

    end

    function result = GenerateMarkerClasses(obj, EEG, classPatterns, varargin)

        p = inputParser;
        p.addRequired(p, 'EEG', @(x) isfield(x, 'event'));
        p.addRequired(p, 'classPatterns', @(x) isa(x, 'MarkerPattern') );

        parse(p, EEG, classPatterns, varargin{:});

        result = GenerateEventClasses(EEG, classPatterns, varargin);
    end
  end
end
