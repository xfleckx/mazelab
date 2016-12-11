function result = subset(eventSet, beginValue, endValue, varargin )

%% Input validation
        p = inputParser;
        addRequired(p,'eventSet',@isvector);
        addRequired(p,'beginValue',@ischar);
        addRequired(p,'endValue',@ischar)

        argName = 'ignoreEmpty';
        default = 0;
        valIgnore =  @(x) isnumeric(x) && isscalar(x) && (x == 0 || x == 1);
        addOptional(p,argName,default);


        argName = 'verbose';
        default = 0;
        valIgnore =  @(x) isnumeric(x) && isscalar(x) && (x == 0 || x == 1);
        addOptional(p,argName,default);

        parse(p, eventSet, beginValue, endValue, varargin{:});
        args = p.Results;

%% Function logic
        if(args.verbose)
            disp(['Slice between: "' beginValue '" --> "' endValue '"']);
        end

        matches = arrayfun(@(x)... 
                    ~isempty(regexp(x.type, beginValue, 'match')) || ...
                    ~isempty(regexp(x.type, endValue, 'match')), eventSet);

        if ~any(matches) 
            if args.ignoreEmpty
                result = {};
                return;
            else
                error('No matches found maybe the Regex pattern is wrong?');
            end
        end
        
        boundsIdx = find(matches); %get positions of matches
        
        boundsCount = length(boundsIdx);

        if mod(boundsCount,2)
            error('An even number of boundaries are expectet! \n Potential reasons could be an serial ambiguity Try to use context_subset instead.');
        end

        expectedCountOfBoundTuples = boundsCount / 2;
        
        if(args.verbose)
            disp(['Results in ' num2str(expectedCountOfBoundTuples) ' segments']);
        end
        
        bounds = reshape(boundsIdx, [2, expectedCountOfBoundTuples]);
        
        result = {};
        resultIndex = 1;

        for bound = bounds

            eventSetForCurrentBounds = eventSet(bound(1):bound(2));
            
            result{resultIndex} = eventSetForCurrentBounds; 
            resultIndex = resultIndex + 1;
        end
end