classdef EventConverter < handle
    properties 
        % A vector of pattern-class pair
        PatternForEventClasses = []
        % A pattern extracting Trial Types
        TrialTypePattern
        % A pattern extracting condition names
        ConditionTypePattern
    end

    methods (Access = public)
        
        function Create(obj, eventPattern, markerClass)
        
            p = inputParser;
            addRequired(p, 'pattern', @ischar);
            addRequired(p, 'eventClass', @ischar);
            parse(p, eventPattern, markerClass);

            if obj.knowsThis(markerClass)
                error('You tried to push a MarkerClass which already exists!');
            end

            if isempty(obj.PatternForEventClasses)
                obj.PatternForEventClasses = MarkerPattern(eventPattern, markerClass);
                return;
            end

            obj.PatternForEventClasses(end+1)= MarkerPattern(eventPattern, markerClass);
        end

        function Clear(obj)
            obj.PatternForEventClasses = [];
        end

        function nPatterns = GetCountOfEventClasses(obj)
            nPatterns = numel(obj.PatternForEventClasses);
        end

         function [result, name] = ContainsAConditionName(obj, eventString)
             [result, name] = obj.check(obj.ConditionTypePattern, eventString);
        end

        function [result, name] = ContainsATrialType(obj, eventString)
             [result, name] = obj.check(obj.TrialTypePattern, eventString);
        end
    end

    methods (Access = private)
        function [result, name] = check(obj, pattern, stringToTest)

            name = regexp(stringToTest, pattern, 'tokens');

            result = ~isempty(name);

            if result
                name = name{1}{1};
            end
        end

        function knowsIt = knowsThis(obj, markerClass)
           results = arrayfun(@(x) strcmp(x, markerClass), obj.PatternForEventClasses);
           knowsIt = any(results);
        end
    end
end