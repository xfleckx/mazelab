function [EEG, conversionResult] = GenerateEventClasses( EEG, eventConverter, varargin)
% GenerateAbstractEvents  Create more abstract Events from context specific Events. 
%   Example 'TURN From... To... L ' will become L TURN
%   Intention is to increase sample size for different epochs.
%   INPUTS
%   classes = Two dimensional cell array containing a regex pattern repräsenting a classes
%                   and it's corresponding marker class  classes{a,1} should return the

    EEGLabExt.Check(EEG, 'ignoreUrevents');

    p = inputParser;
    p.addRequired('EEG', @(x) isfield(x, 'event'));
    p.addRequired('eventConverter', @(x) isa(x, 'EventConverter') );
    p.addOptional('preserveOriginals', 0);
    p.addOptional('verbose', 0);
    
    p.parse(EEG, eventConverter, varargin{:});

    beVerbose = p.Results.verbose;

    conversionResult.markersUntouched = {};
    conversionResult.totalMarkersUntouched = 0;

    nevents = numel(EEG.event);

    if nevents < 1
        disp('Nothing to do, EEG.event is empty');
    end

    npattern = eventConverter.GetCountOfEventClasses();

    nameOfCondition = '';
    nameOfTrialType = '';

    for e_i = 1 : nevents
        evt = EEG.event(e_i);
        
        if(e_i == 1)
            EEG.urevent = evt;
        else
            EEG.urevent(e_i) = evt;
        end
        
        markerTouched = false;
        
        if beVerbose
            disp('__________')
            disp(['Try matching: ' sprintf(evt.type) ' with regex: ']);
        end

        for p_i = 1 : npattern
            pair = eventConverter.PatternForEventClasses(p_i);
            
            if beVerbose
                disp(pair.Pattern);
            end

            [isACondition, name] = eventConverter.ContainsAConditionName(evt.type);
            if isACondition
                if beVerbose
                    disp(['Marker: '  sprintf(evt.type) ' contains Condition:' name]);
                end
                nameOfCondition = name;
            end
                
            [isATrialType, name] = eventConverter.ContainsATrialType(evt.type);
            if isATrialType
                if beVerbose
                disp(['Marker: ' sprintf(evt.type) ' contains Trial:' name]);
                end
                nameOfTrialType = name;
            end
            
            tryMatching  = regexp(evt.type, pair.Pattern, 'match');

            if isempty(tryMatching)
                continue;
            end
            
            if beVerbose
                disp('Match found...');
            end

            markerTouched = true;
            
            markerClass = [nameOfCondition ' ' nameOfTrialType ' ' pair.EventClass]; % Make the type of the new event
            
            markerClass = strtrim(markerClass);

            if p.Results.preserveOriginals
                if beVerbose
                    disp(['Add new Event: '  markerClass ' based on: ' sprintf(evt.type)]);
                end
                EEG.event(end+1).type = markerClass;
                EEG.event(end).latency = evt.latency;
                EEG.event(end).duration = evt.duration;
            end

            if ~p.Results.preserveOriginals
                if beVerbose
                    disp(['Convert: ' sprintf(evt.type) ' => ' markerClass]);
                end
                EEG.event(e_i).type = markerClass;
            end
        end

        if ~markerTouched 
            conversionResult.totalMarkersUntouched = conversionResult.totalMarkersUntouched + 1;
            conversionResult.markersUntouched{end+1} = evt.type;
        end 
                
    end

end