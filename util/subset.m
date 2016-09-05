function [ resultAsStructuredArray ] = subset(eventSet, beginValue, endValue)

        disp(['Subset [' beginValue ' --> ' endValue ']' ]);

        matches = arrayfun(@(x)... 
        ~isempty(regexp(x.type, beginValue, 'match')) || ...
        ~isempty(regexp(x.type, endValue, 'match')), eventSet);

        if all(matches)
            %error('No matches found maybe the Regex pattern is wrong?');
        end
    
        boundsIdx = find(matches);

        bounds = reshape(boundsIdx, [2, length(boundsIdx) / 2]);
        
        segmentCount = length(bounds/2);

        disp(['Results in ' num2str(segmentCount) ' segments']);

        resultAsStructuredArray = [];

        for bound = bounds

            eventSetForCurrentBounds = eventSet(bound(1):bound(2));

            if isempty(resultAsStructuredArray)
                resultAsStructuredArray.set = eventSetForCurrentBounds;
            else
                resultAsStructuredArray(end+1).set = eventSetForCurrentBounds;
            end;  
        end
end