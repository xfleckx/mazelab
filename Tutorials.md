# Slicing data sets in MATLAB

The following is given:

```matlab
origin = { 'a' 'h' 'b' 't' 'b_' 'b' 't' 'b_' 'h_' 'a_' }
```

We would like to have the 't' elements by cutting them out on there boundaries set be 'b' and 'b_'.

First get all of the boundaries and sustain their positions in the original dataset.

```matlab
boundaries = arrayfun(@(x)strcmp(x, 'b') || strcmp(x, 'b_'), origin)
```
Which will result in:

>  0     0     1     0     1     1     0     1     0     0

Than find the indices by using matlabs `find(X)` function:

```matlab
indicesOfBoundaries = find(boundaries)
```
Which will result in:

>  3     5     6     8

indicating which positions math either the start or the end condition. 
Assuming that they are still in the correct order, we shape them into an array of 2D vectors.

```matlab
bounds = reshape(indicesOfBoundaries, [2, length(indicesOfBoundaries) / 2])
```

and use them to get the range including the boundaries
```matlab
result = []
for bound = bounds
  result = [result; origin(bounds(1):bounds(2))] 
end
```

or excluding the boundaries
```matlab
result  = []
for bound = bounds
    result = [result; origin(bounds(1)+1:bounds(2)-1)]
end
```

# Construction of regular expressions in MATLAB

## Important features

Joining a string based on several components written by hand:
```matlab
aJoinedString = ['a' 'b' 'c']; 
```
> 'abc'
Joining a string based on several components defined as a cell array:
```matlab
ca = {'Training' 'Experiment'};
aJoinedOR = strjoin(ca,'|');
```
> 'Training|Experiment'

# Displaying on the Console

```matlab
message = ['a' 'b' 'c'];
error(message); % gets printed in red
fprinf(2, message); % also prints in red
disp(message); % gets printed in normal text color
fprinf(1, message); also prints in normal text color
```