function resultSet = contextSubset(eventSet, beginValue, endValue, varargin )
p = inputParser;

expectedOptions = {'adjacent','nonadjacent'};

addRequired(p,'beginValue', @ischar);
addRequired(p,'endValue', @ischar);

defaultOp = 'adjacent';
addParameter(p, 'contextOp', defaultOp, ...
                @(x)any(validatestring(x, expectedOptions)))

parse(p, beginValue, endValue, varargin{:});

inputs = p.Results;

eventCount = length(eventSet);

resultIndices = [];

if inputs.contextOp == 'adjacent';
   resultIndices = SubsetAtAdjacentEvents(eventSet, eventCount, beginValue, endValue);
end

countOfBounds = length(resultIndices);

resultSet = [];

for index = resultIndices
    
    result = eventSet(index(1):index(2));
    
    if isempty(resultSet)
        resultSet.set = result;
    else
        resultSet(end+1).set = result;
    end;  
end

end

function resultSet = SubsetAtAdjacentEvents(eventSet, eventCount, beginValue, endValue)

    IndexAtContextBegin = 0;
    IndexAtContextEnd = 0;
    inContext = 0; % flag for being already in a context
    resultSet = [];
    for index = 1:eventCount
        current = eventSet(index);
         
        % is current a context begin?
        contextStartMatch = regexp(current.type, beginValue, 'match');
        contextEndMatch = regexp(current.type, endValue, 'match');
        
        currentMatchesStart = ~ isempty(contextStartMatch);
        currentMatchesEnd = ~ isempty(contextEndMatch); 

        if currentMatchesStart && ~ inContext

            IndexAtContextBegin = index;
            inContext = 1;

        end 

        if inContext && currentMatchesEnd

            IndexAtContextEnd = index;
            inContext = 0;
            resultSet = [resultSet [IndexAtContextBegin; IndexAtContextEnd]]; 

        end
    end
end
