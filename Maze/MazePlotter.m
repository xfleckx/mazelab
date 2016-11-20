classdef MazePlotter < handle
    
    properties (Access = public, Constant)
        DefaultKernel = [ ...
                            0 0 0 0 ; ...
                            0 1 1 0 ; ...
                            0 1 1 0 ; ...
                            0 0 0 0];
    end

    properties (Access = private)
        plotMatrix
    end

    methods (Access = public)
        function obj = preparePlot(obj, mazeMatrix, varargin)
            
            p = inputParser;
            addOptional(p, 'debugMode', 0);
            addRequired(p, 'mazeMatrix', @ismatrix);
            
            parse(p, mazeMatrix, varargin{:});

            obj.plotMatrix = kron(mazeMatrix, obj.DefaultKernel);
            [om, on] = size(mazeMatrix);
            
            [m,n] = size(obj.DefaultKernel);

            for i = 1:om
                for j = 1:on
                source = mazeMatrix(i,j);
                kernel = obj.getKernelFor(source);
                
                if p.Results.debugMode
                    disp(['Using: this for ' num2str(source) ' on c:' num2str(i) ' r: ' num2str(j) ]); 
                    disp(kernel);
                end
                x0 = i*m - m +1;
                x1 = i*m;
                y0 = j*n - n +1;
                y1 = j*n;

                obj.plotMatrix(x0:x1,y0:y1) = kernel;

                end
            end
        end

        function obj = ApplyData(obj, matrixContainingData)

            if isempty(obj.plotMatrix)
                error('Call preparePlot() first!');
            end

            kernel = ones( size(obj.DefaultKernel) );

            extraPolatedDataMatrix = kron(matrixContainingData, kernel);

            obj.plotMatrix = obj.plotMatrix .* extraPolatedDataMatrix; 
        end

       function PlotAsImageSc(obj, varargin)

                p = inputParser;
                addOptional(p, 'mazeOnly', 1);
                addOptional(p, 'noFigure', 1);
                addOptional(p, 'debugMode', 0);
                addOptional(p, 'title', 'Title');

                parse(p, varargin{:});
 
                sizeOfPlotMatrix = size(obj.plotMatrix);
                
                if ~p.Results.noFigure
                    figure;
                end
                
                imagesc(flipud(obj.plotMatrix));
                title(p.Results.title);
                set(gca,'YDir','normal');
                set(gca,'xtick',[])
                set(gca,'ytick',[])
                colormap('gray');
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