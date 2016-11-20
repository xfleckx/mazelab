classdef ExperimentStatistics
    % EXPERIMENTSTATISTICS A representation of common statistical values for one subject / experiment
    %
    properties
        subject
    end
    
    properties  (Access = private)
        
    end

    properties  (Access = public)
        Trials
    end

    methods (Access = private)
        
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
        function duration = getSummarizedDuration(obj)
            seconds = sum( arrayfun(@(x) x.getDuration(), obj.Trials) );
            duration = seconds / 60;
        end
        function summary = summarize(obj)
            summary.totalTrials = numel(obj.Trials);
            summary.totalWrongDecisions = 0; % todo
            summary.DurationOfExperiment = [sprintf('%s', num2str(obj.getSummarizedDuration())) ' min']; 
            mazesUsed = unique( [ obj.Trials.Maze ] );
            summary.environments = { mazesUsed.Name };
        end

    end
    
end