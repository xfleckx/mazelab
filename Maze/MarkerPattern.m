classdef MarkerPattern
    %MAZEMODEL A representation of a MoBI Maze 
    properties 
        % Should be a regex pattern describing a marker
        Pattern
        % Should be a string describing the event
        EventClass
    end

    methods
        function obj = MarkerPattern(pattern, eventClass)

        obj.Pattern = pattern;
        obj.EventClass = eventClass;
            
        end
    end
end