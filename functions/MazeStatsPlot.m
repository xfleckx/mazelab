function figureHandle = MazeStatsPlot(mazeStatistics, varargin)
%MazeStatsPlot - Description
%
% Syntax: output = MazeStatsPlot(input)
%
% Long description

p = inputParser;

validateInputAsInstanceOfMazeStat = @(x) isa(x,'MazeStatistics');
addRequired(p, 'input', validateInputAsInstanceOfMazeStat);
addOptional(p, 'onlyTics', false, @islogical);

parse(p, mazeStatistics, varargin{:})

%result = kron(S, kernelSize);

sizeOfMazeMatrix = size(mazeStatistics.MazeMatrix);

dataToPlot = mazeStatistics.MazeMatrix;

if p.Results.onlyTics
  dataToPlot = mazeStatistics.MazeModel.Matrix + dataToPlot;
end

plotTitle = ['Time in Cell: ' mazeStatistics.MazeModel.Name ' Path ' mazeStatistics.Path];

figureHandle = figure('Name', plotTitle);

ih = imagesc(flipud(dataToPlot));

set(gca,'YDir','normal');
title(plotTitle);

colormap('gray');
cb = colorbar;
set(get(cb,'title'),'string','(Sec)');
pbaspect([sizeOfMazeMatrix(2) sizeOfMazeMatrix(1) 1]);
end
