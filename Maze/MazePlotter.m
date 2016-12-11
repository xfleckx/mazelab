classdef MazePlotter < handle
    
    properties (Access = public, Constant)
        DefaultKernel = [ ...
                            0 0 0 0 ; ...
                            0 1 1 0 ; ...
                            0 1 1 0 ; ...
                            0 0 0 0];

        DefaultColorMap = [ 1, 1, 1 
                            0, 0, 0 ];
                        
        StructureColorMap = [ 1, 1, 1
                              0.1, 0.6, 1 ];
                            
    end

    properties (Access = private)
        plotMatrix
        matrixAfterKernelApplication
        initialMazeMatrix
        mazeAndDataMatrix
        
        rows
        cols
    end

    methods (Access = public)
        function obj = preparePlot(obj, mazeMatrix, varargin)
            
            p = inputParser;
            addOptional(p, 'debugMode', 0);
            addOptional(p, 'doNotExtrapolate', 0);
            addRequired(p, 'mazeMatrix', @ismatrix);
            
            parse(p, mazeMatrix, varargin{:});
            
            obj.initialMazeMatrix = mazeMatrix;

            if p.Results.doNotExtrapolate
                obj.matrixAfterKernelApplication = mazeMatrix;
                m = 1;
                n = 1;
            else
                obj.matrixAfterKernelApplication = kron(mazeMatrix, obj.DefaultKernel);
                [m,n] = size(obj.DefaultKernel);
            end
            
            sizeOfInitialMazeMatrix = size(obj.initialMazeMatrix);
            
            obj.cols = sizeOfInitialMazeMatrix(2);
            obj.rows = sizeOfInitialMazeMatrix(1);
            
            [om, on] = size(obj.initialMazeMatrix);
            
            for i = 1:om
                for j = 1:on
                source = mazeMatrix(i,j);
                
                if p.Results.doNotExtrapolate
                    kernel = ones(1,1);
                else
                    kernel = obj.getKernelFor(source);
                end
                
                if p.Results.debugMode
                    disp(['Using: this for ' num2str(source) ' on c:' num2str(i) ' r: ' num2str(j) ]); 
                    disp(kernel);
                end
                
                x0 = i*m - m +1;
                x1 = i*m;
                y0 = j*n - n +1;
                y1 = j*n;

                obj.matrixAfterKernelApplication(x0:x1,y0:y1) = kernel;

                end
            end
            
            obj.matrixAfterKernelApplication(obj.plotMatrix == 0) = NaN;
        end

        function obj = ApplyData(obj, matrixContainingData, varargin)

            p = inputParser;
            addOptional(p, 'doNotExtrapolate', 0);
            addRequired(p, 'mazeMatrix', @ismatrix);
            parse(p, matrixContainingData, varargin{:});
            
            if isempty(obj.matrixAfterKernelApplication)
                error('Call preparePlot() first!');
            end


            if p.Results.doNotExtrapolate
                obj.mazeAndDataMatrix = obj.matrixAfterKernelApplication .* matrixContainingData;
            else 
                kernel = ones( size(obj.DefaultKernel) );
                extraPolatedDataMatrix = kron(matrixContainingData, kernel);
                obj.mazeAndDataMatrix = obj.matrixAfterKernelApplication .* extraPolatedDataMatrix; 
            end
            
        end

        function matrix = ReturnExtrapolatedMatrix(obj)
            matrix = obj.matrixAfterKernelApplication;
        end
        
        function matrix = ReturnPlotMatrix(obj)
        %% just Return the matrix for custom plot functions
            matrix = obj.mazeAndDataMatrix;
        end

        function PlotAsColormap(obj, varargin)
            
                p = inputParser;
                addOptional(p, 'mazeOnly', 1);
                addOptional(p, 'noFigure', 1);
                addOptional(p, 'debugMode', 0);
                addOptional(p, 'useKernelMode',1);
                addOptional(p, 'title', 'Title');
                addOptional(p, 'colormap', obj.DefaultColorMap);
                addOptional(p, 'noLegend', 0);

                parse(p, varargin{:});
                
                if ~isempty(obj.mazeAndDataMatrix) && p.Results.useKernelMode
                    matrixToPlot = obj.mazeAndDataMatrix;
                else
                    matrixToPlot = obj.initialMazeMatrix;
                end

                sizeOfPlotMatrix = size(matrixToPlot);
                
                imagesc(flipud(matrixToPlot));
                title(p.Results.title);
                set(gca,'YDir','normal');
                
                if ~p.Results.noLegend
                colorbar('Ticks',[0.2, 0.8],...
                       'TickLabels',{'No Cell','Hallway'}); 
                end


                xtick = linspace(1,sizeOfPlotMatrix(2), obj.cols);
                set(gca,'xtick', xtick);
                set(gca, 'xticklabels', arrayfun(@num2str, linspace(1,obj.cols,obj.cols), 'UniformOutput', false));

                ytick = linspace(1,sizeOfPlotMatrix(1), obj.rows);
                set(gca,'ytick', ytick);

                set(gca, 'yticklabels', arrayfun(@num2str, linspace(1,obj.rows,obj.rows), 'UniformOutput', false));
            
                colormap(p.Results.colormap);
                
                pbaspect([sizeOfPlotMatrix(2) sizeOfPlotMatrix(1) 1]);
        end

        function PlotAsImageSc(obj, varargin)

                p = inputParser;
                addOptional(p, 'mazeOnly', 1);
                addOptional(p, 'noFigure', 1);
                addOptional(p, 'debugMode', 0);
                addOptional(p, 'title', 'Structure');
                addOptional(p, 'barTitle', 'unit');
                addOptional(p, 'colormap', obj.DefaultColorMap);
                addOptional(p, 'noLegend', 0);

                parse(p, varargin{:});
 
                obj.plotMatrix = obj.mazeAndDataMatrix;
            
                sizeOfPlotMatrix = size(obj.plotMatrix);
                
                if ~p.Results.noFigure
                    figure;
                end
                
                imagesc(flipud(obj.plotMatrix));
                t = title(p.Results.title);
%                 P = get(t,'position');
%                 set(t,'rotation',-90,'position',[P(2) P(1) P(3)])
                set(gca,'YDir','normal');
                
                xtick = linspace(1,sizeOfPlotMatrix(2), obj.cols);
                set(gca,'xtick', xtick);
                set(gca, 'xticklabels', arrayfun(@num2str, linspace(1,obj.cols,obj.cols), 'UniformOutput', false));

                ytick = linspace(1,sizeOfPlotMatrix(1), obj.rows);
                set(gca,'ytick', ytick);

                set(gca, 'yticklabels', arrayfun(@num2str, linspace(1,obj.rows,obj.rows), 'UniformOutput', false));
                colormap(p.Results.colormap);
                cb = colorbar;
                %ylabel(cb,p.Results.barTitle)
                title(cb,p.Results.barTitle)
                
                
%                 if ~p.Results.noLegend
%                 colorbar('Ticks',[0.3, 0.6],...
%                        'TickLabels',{'No Cell','Hallway'}); 
%                 end

                pbaspect([sizeOfPlotMatrix(2) sizeOfPlotMatrix(1) 1]);
        end

        function PlotStructure(obj, varargin)
            p = inputParser;
            
            availablePlotModes = {'imagesc' 'pcolor'};
            errorMessage = 'PlotMode could be imagesc or pcolor';
            validPlotMode = @(x) assert(ischar(x) && any(ismember(availablePlotModes, x)), errorMessage);
            addParameter(p, 'plotMode', availablePlotModes{1}, validPlotMode); 
            addOptional(p, 'useKernelMode',1);
            addOptional(p, 'mazeOnly', 1);
            addOptional(p, 'noColorbar', 1);
            addOptional(p, 'noFigure', 1);
            addOptional(p, 'debugMode', 0);
            addOptional(p, 'title', 'Structureplot');
            addOptional(p, 'colormap', obj.StructureColorMap);
            
            parse(p, varargin{:});
 
            if p.Results.useKernelMode
                obj.plotMatrix = obj.matrixAfterKernelApplication;
            else
                obj.plotMatrix = obj.initialMazeMatrix;
            end
            
            sizeOfPlotMatrix = size(obj.plotMatrix);
            
            flipedMatrix = flipud(obj.plotMatrix);
            
            if strcmp(p.Results.plotMode, availablePlotModes{1})
                imagesc(flipedMatrix);
            else
                pcolor(flipedMatrix);
            end
            
            title(p.Results.title);
            colormap(p.Results.colormap);
            
            if ~p.Results.noColorbar
            colorbar('location','southoutside',...
                            'Ticks',[0.333333, 0.666666],...
                            'TickLabels',{'No Unit','Unit'}); 
            end
            
            xtick = linspace(1,sizeOfPlotMatrix(2), obj.cols);
            set(gca,'xtick', xtick);
            set(gca, 'xticklabels', arrayfun(@num2str, linspace(1,obj.cols,obj.cols), 'UniformOutput', false));
              
            set(gca,'YDir','normal');
            ytick = linspace(1,sizeOfPlotMatrix(1), obj.rows);
            set(gca,'ytick', ytick);
              
            set(gca, 'yticklabels', arrayfun(@num2str, linspace(1,obj.rows,obj.rows), 'UniformOutput', false));
             
            pbaspect([sizeOfPlotMatrix(2) sizeOfPlotMatrix(1) 1]);
        end
    end

    methods (Access = private)
        function kernel = getKernelFor(obj, unitCode)

        % 1 % North 
        % 2 % South
        % 4 % Osten
        % 8 % Westen

        kernel = zeros(4,4);
        
        if unitCode == 1
            kernel = [ ...
                    0 1 1 0 ; ...
                    0 1 1 0 ; ...
                    0 1 1 0 ; ...
                    0 0 0 0 ];
                    return;
        end
        
        if unitCode == 2
            kernel = [ ...
                    0 0 0 0 ; ...
                    0 1 1 0 ; ...
                    0 1 1 0 ; ...
                    0 1 1 0 ];
                    return;
        end
        
        if unitCode == 4
            kernel = [ ...
                    0 0 0 0 ; ...
                    0 1 1 1 ; ...
                    0 1 1 1 ; ...
                    0 0 0 0 ];
                    return;
        end
        
        if unitCode == 8
            kernel = [ ...
                    0 0 0 0 ; ...
                    1 1 1 0 ; ...
                    1 1 1 0 ; ...
                    0 0 0 0];
                    return;
        end


        % 3  % North | South
        % 6  % South | East
        % 9  % North | West
        % 10 % South | West
        % 12 % East | West
        % 5  % North | East

        if unitCode == 5
            kernel = [ ...
                    0 1 1 0; ...
                    0 1 1 1; ...
                    0 1 1 1; ...
                    0 0 0 0 ];
                    return;
        end
        
        if unitCode == 6
            kernel = [ ...
                    0 0 0 0; ...
                    0 1 1 1; ...
                    0 1 1 1; ...
                    0 1 1 0 ];
                    return;
        end

        if unitCode == 9
            kernel = [ ...
                    0 1 1 0; ...
                    1 1 1 0; ...
                    1 1 1 0; ...
                    0 0 0 0 ];
                    return;
        end

        if unitCode == 3
            kernel = [ ...
                    0 1 1 0; ...
                    0 1 1 0; ...
                    0 1 1 0; ...
                    0 1 1 0 ];
                    return;
        end
        
        if unitCode == 12
            kernel = [ ...
                    0 0 0 0; ...
                    1 1 1 1; ...
                    1 1 1 1; ...
                    0 0 0 0 ];
                    return;
        end

        if unitCode == 7
            kernel = [ ...
                    0 1 1 0; ...
                    0 1 1 1; ...
                    0 1 1 1; ...
                    0 1 1 0 ];
                    return;
        end

        if unitCode == 10
            kernel = [ ...
                    0 0 0 0; ...
                    1 1 1 0; ...
                    1 1 1 0; ...
                    0 1 1 0 ];
                    return;
        end

        if unitCode == 11
            kernel = [ ...
                    0 1 1 0; ...
                    1 1 1 0; ...
                    1 1 1 0; ...
                    0 1 1 0 ];
                    return;
        end

        if unitCode == 13
            kernel = [ ...
                    0 1 1 0; ...
                    1 1 1 1; ...
                    1 1 1 1; ...
                    0 0 0 0 ];
        end
        
        if unitCode == 14
            kernel = [ ...
                    0 0 0 0; ...
                    1 1 1 1; ...
                    1 1 1 1; ...
                    0 1 1 0 ];
                    return;
        end
        
        return;
        end
    end

end