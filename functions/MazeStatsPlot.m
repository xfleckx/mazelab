function figureHandle = MazeStatsPlot(input, varargin)
%MazeStatsPlot - Description
%
% Syntax: output = MazeStatsPlot(input)
%
% Long description

p = inputParser;

validateInputAsInstanceOfMazeStat = @(x) isa(x,'MazeStatistics');
addRequired(p, 'input', validateInputAsInstanceOfMazeStat);
addOptional(p, 'onlyTics', false, @islogical);

parse(p, input, varargin{:})

sizeOfMazeMatrix = size(input.MazeMatrix);

dataToPlot = input.MazeMatrix;

if p.Results.onlyTics
  dataToPlot = input.MazeModel.Matrix + dataToPlot;
end

plotTitle = ['Time in Cell: ' input.MazeModel.Name ' Path ' input.Path];

figureHandle = figure('Name', plotTitle);

ih = imagesc(flipud(dataToPlot));

set(gca,'YDir','normal');
title(plotTitle);

colormap('gray');
cb = colorbar;
set(get(cb,'title'),'string','(Sec)');
pbaspect([sizeOfMazeMatrix(2) sizeOfMazeMatrix(1) 1]);
end
