classdef ExperimentStatistics
    %MazeStatistics A representation of common statistical values for one subject on a MoBI Maze
    properties
        subject
    end
    
    properties  (Access = private)
    end

    properties  (Access = public)
        Trials
    end

    methods
        function obj = ExperimentStatistics(subject)
        obj.subject = subject;
        end;
        function selectedTrials = GetTrialsBy(obj, attribute, attributeValue)
        % maybe this could be solved by logical indexing
        selectedTrials = [];
            if isfield(obj.Trials,attribute)
                selectedTrials = arrayfun(@(t) getfield(t,attribute) == attributeValue,obj.Trials,'UniformOutput',1) 
            end
        end
        function summary = summarize(obj)
            summary.totalTrials = numel(obj.Trials);
            mazesUsed = unique( [ obj.Trials.Maze ] );
            summary.environments = { mazesUsed.Name };
        end
    end
    
end