classdef MarkerPattern
    %MAZEMODEL A representation of a MoBI Maze 
    properties 
        % Should be a regex pattern describing a marker
        Pattern
        % Should be a string describing the event
        EventClass
    end

    properties (Access = private)
        patternExtractingTrialType
        patternExtractingConditionType
    end

    methods
        function obj = MarkerPattern(pattern, eventClass, varargin)

        p = inputParser;
        addOptional(p, 'trialType', @(x) ischar(x), '');
        addOptional(p, 'conditionType', @(x) ischar(x), '');
        parse(p, patter, eventClass, varargin{:});

        obj.patternExtractingTrialType = p.Results.trialType;
        obj.patternExtractingConditionType = p.Results.conditionType;

        obj.Pattern = pattern;
        obj.EventClass = eventClass;
            
        end

        function [result, name] = DescribesACondition(obj, eventString)
            result = ~isempty(obj.patternExtractingConditionType);
            name = regexp(eventString, obj.patternExtractingConditionType, 'tokens');
            name = name{1};
        end

        function [result, name] = DescribesATrialType(obj, eventString)
            result = ~isempty(obj.patternExtractingTrialType); 
            name = regexp(eventString, obj.patternExtractingTrialType, 'tokens');
            name = name{1};
        end

    end
end