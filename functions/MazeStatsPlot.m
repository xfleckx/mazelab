function output = MazeStatsPlot(input, varargin)
%MazeStatsPlot - Description
%
% Syntax: output = MazeStatsPlot(input)
%
% Long description

p = inputParser;

validateInputAsInstanceOfMazeStat = @(x) isa(x,'MazeStatistics');
addRequired(p, 'input', validateInputAsInstanceOfMazeStat)

parse(p, input, varargin{:})

output = figure('Name', 'Tics within this Maze');
imagesc(input.MazeMatrix);
colormap('gray');
colorbar;

end