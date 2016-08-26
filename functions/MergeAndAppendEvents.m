function [ EEG ] = GenerateAbstractEvents( EEG )
% GenerateAbstractEvents  Create more abstract Events from context specific Events. 
%   Example 'TURN From... To... L ' will become L TURN
%   Intention is to increase sample size for different epochs.

    EEGLabExt.Check(EEG, 'ignoreUrevents');

    MazeLab.Check(MAZELAB);

    nevents = length(EEG.event);
    for index = 1 : nevents
        if ischar(EEG.event(index).type) && strcmpi(EEG.event(index).type, 'square') 
        % Add events relative to existing events
            EEG.event(end+1) = EEG.event(index); % Add event to end of event list
            % Specifying the event latency to be 0.1 sec before the referent event (in real data points) 
            EEG.event(end).latency = EEG.event(index).latency; 
            EEG.event(end).type = 'cue'; % Make the type of the new event 'cue
        end;
    end; 

end;