function [ EEG ] = GenerateEventClasses( EEG, patternClassPairs )
% GenerateAbstractEvents  Create more abstract Events from context specific Events. 
%   Example 'TURN From... To... L ' will become L TURN
%   Intention is to increase sample size for different epochs.
%   INPUTS
%   patternClassPairs = Two dimensional cell array containing a regex pattern repräsenting a patternClassPairs
%                   and it's corresponding marker class  patternClassPairs{a,1} should return the

    EEGLabExt.Check(EEG, 'ignoreUrevents');

    MazeLab.Check(MAZELAB);

    if ~isa(patternClassPairs, 'MarkerPattern')
        error('Second parameter should be object or a array of typ MarkerPattern')
    end;
    
    nevents = length(EEG.event);

    npattern = length(patternClassPairs);

    nameOfCondition = '';

    for index = 1 : nevents
        type = EEG.event(index).type;
        
            for patternIndex = 1 : npattern
                pair = patternClassPairs(patternIndex);

                if ischar(type) && regexp(type, pair.Pattern) 

                    % Add events relative to existing events
                    EEG.event(end+1) = EEG.event(index); % Add event to end of event list
                    
                    newEventType = [nameOfCondition ' ' pair.EventClass]; % Make the type of the new event
                    
                    % be aware that end has already changed
                    EEG.event(end).type = newEventType;
                    % Specifying the event latency to be 0.1 sec before the referent event (in real data points) 
                    EEG.event(end).latency = EEG.event(index).latency; 

                end;
            end;
    end; 

end;