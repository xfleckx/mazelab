function plotMatrix = renderMazeMatrix(mazeMatrix, kernel, varargin)

    p = inputParser;
    addOptional(p, 'debugMode', 0);
    addRequired(p, 'mazeMatrix', @ismatrix);
    addRequired(p, 'kernel', @ismatrix);

    parse(p, mazeMatrix, kernel, varargin{:});

    plotMatrix = kron(mazeMatrix, kernel);
    [om, on] = size(mazeMatrix);
    
    [m,n] = size(kernel);

    for i = 1:om
        for j = 1:on
           source = mazeMatrix(i,j);
           kernel = GetKernelFor(source);
           
           if p.Results.debugMode
              disp(['Using: this for ' num2str(source) ' on c:' num2str(i) ' r: ' num2str(j) ]); 
              disp(kernel);
           end
           x0 = i*m - m +1;
           x1 = i*m;
           y0 = j*n - n +1;
           y1 = j*n;
           
           plotMatrix(x0:x1,y0:y1) = kernel;
        end
    end
end