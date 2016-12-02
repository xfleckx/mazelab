function result = GenerateEventClasses( EEG, classes, varargin)
% GenerateAbstractEvents  Create more abstract Events from context specific Events. 
%   Example 'TURN From... To... L ' will become L TURN
%   Intention is to increase sample size for different epochs.
%   INPUTS
%   classes = Two dimensional cell array containing a regex pattern repräsenting a classes
%                   and it's corresponding marker class  classes{a,1} should return the

    EEGLabExt.Check(EEG, 'ignoreUrevents');

    p = inputParser;
    p.addOptional(p, 'preserveOriginals', false);
    
    result.markersUntouched = {};
    result.totalMarkersUntouched = 0;

    nevents = numel(EEG.event);

    npattern = numel(classes);

    nameOfCondition = '';
    nameOfTrialType = '';

    for e_i = 1 : nevents
        evt = EEG.event(e_i);
        
        markerTouched = false;

            for p_i = 1 : npattern
                pair = classes(p_i);

                if regexp(evt.type, pair.Pattern, 'match') 

                    markerTouched = true;

                    if pair.DescribesACondition(evt.type)
                        nameOfCondition = pair.GetConditionName(evt.type);
                    end

                    [isATrialType, name] = pair.DescribesATrialType(evt.type)
                        nameOfTrialType = pair.GetTrialTypeName(evt.type);
                    end
                    
                    newEventType = [nameOfCondition ' ' nameOfTrialType ' ' pair.EventClass]; % Make the type of the new event
                    
                    newEventType = strtrim(newEventType);

                    % be aware that end has already changed
                    EEG.event(end).type = newEventType;
                    % Specifying the event latency to be 0.1 sec before the referent event (in real data points) 
                    EEG.event(end).latency = EEG.event(e_i).latency; 

                    EEG.urevent(e_i) = evt;

                    if p.Results.preserveOriginals
                        EEG.event(end+1).type = markerClass;
                        EEG.event(end).latency = evt.latency;
                        EEG.event(end).duration = evt.duration;
                    else
                        EEG.event(e_i).type = markerClass;
                    end

                end
            end

        if ~markerTouched 
            result.totalMarkersUntouched = result.totalMarkersUntouched + 1;
            markersUntouched{end+1} = evt.marker;
        end 
                
    end

end



    for e_i = 1:numel(EEG.event)

        evt = EEG.event(e_i);

        for p_i = 1:numel(classPatterns)

            regex = classPatterns{p_i}{1};
            markerClass = classPatterns{p_i}{2};

            if regexp(evt.type,regex,'match')
               markerTouched = true;
               
               
            end
        end
