function EEG = CorrectLatencies( EEG, correction )
% CorrectLatencies: Short description
%
% Extended description
eventCount = length(EEG.event);

for i = 1:eventCount

  original = EEG.event(i).latency;
  EEG.event(i).latency = original * correction;

end

end  % CorrectLatencies
