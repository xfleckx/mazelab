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
    function experiment = CreateExperimentStats(obj, EEG, trialTypes, conditions, subject)
       p = inputParser;
       valEvents = @(x) isfield(x,'event') && ~isempty(x.event);
       addRequired(p, 'EEG', valEvents);
       addRequired(p, 'trialTypes', @iscell);
       addRequired(p, 'conditions', @iscell);
       addRequired(p, 'subject', @ischar);

       parse(p, EEG, trialTypes, conditions, subject);

       experiment = BuildExperiment(EEG, obj, trialTypes, conditions, subject);
    end
    function fig = PlotOverview(obj,varargin)

        p = inputParser;
        addOptional(p,'all',1);
        parse(p, varargin{:});

        mazesCount = numel(obj.MAZES);
        % Bug here... this won't work for even maze count
        rows = mod(mazesCount, ceil(mazesCount / 2));
        cols = mod(mazesCount, ceil(mazesCount / 2));

        fig = figure;

        for i = 1:mazesCount

            subplot(rows, cols, i);
            PlotAsImageSc(obj.MAZES(i), 'mazeOnly', 1, 'noFigure', 1);
        end

    end
  end
end
