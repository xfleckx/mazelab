function PlotAResultSet( res, MAZELAB)
%PLOTARESULTSET Summary of this function goes here
%   Plot the differences

cm = GetCustomColorMap('colorCount', 1000, 'zeroPosition', 'mid');

plotter = MazePlotter();

subplot = @(m,n,p) subtightplot (m, n, p, [0.1 0.1], [0.06 0.06], [0.1 -0.01]);

for i_r = 1 : numel(res.resultPerMaze)

    result = res.resultPerMaze(i_r);
    
    allResults = [res.resultPerMaze];
    pathsOfThisMaze = where(allResults ,@(r) strcmp(r.Maze, result.Maze));
    
    countOfPaths = numel(pathsOfThisMaze);
    
    subplot(res.countOfEnvironments, countOfPaths, i_r);

    colormap(cm);
    
    maze = where(MAZELAB.MAZES, @(m) strcmp(m.Name, result.Maze));
    currentTitle = [result.Maze{1} ' P:' result.Path{1}];
    
    mazeStructure = maze.Matrix;
    
   sizeOfInitialMazeMatrix= size(mazeStructure);
   cols = sizeOfInitialMazeMatrix(2);
   rows = sizeOfInitialMazeMatrix(1);
    
    plotMatrix = plotter.preparePlot(mazeStructure)...
        .ApplyData(result.Delta)...
        .ReturnPlotMatrix();
    
    %mazeStructure(mazeStructure > 0) = 1;
    plotMatrix(plotMatrix == 0) = NaN;
    
    sizeOfPlotMatrix = size(plotMatrix);
    
    %imagesc(flipud(plotMatrix));
    %pcolor([plotMatrix nan(sizeOfPlotMatrix(2),1); nan(1,sizeOfPlotMatrix(1)+1)]);
    pcolor(flipud(plotMatrix));
    cb = colorbar;

    shading flat
    %   shading interp
    %caxis([res.deltaMin res.deltaMax]);
    caxis([-10 10]);
    pbaspect([sizeOfPlotMatrix(2) sizeOfPlotMatrix(1) 1]);
      
    title(currentTitle);
    title(cb,'Sec'); 
          
    xtick = linspace(1,sizeOfPlotMatrix(2), cols);
    set(gca,'xtick', xtick);
    set(gca, 'xticklabels', arrayfun(@num2str, linspace(1,cols,cols), 'UniformOutput', false));

    set(gca,'YDir','normal');
    ytick = linspace(1,sizeOfPlotMatrix(1), rows);
    set(gca,'ytick', ytick);

    set(gca, 'yticklabels', arrayfun(@num2str, linspace(1,rows,rows), 'UniformOutput', false));
             
    
    
end

%tightfig;

end