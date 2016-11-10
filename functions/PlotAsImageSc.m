function PlotAsImageSc(MazeModel, varargin)

    p = inputParser;
    addOptional(p, 'mazeOnly', 1);
    addOptional(p, 'noFigure', 1);
    
    parse(p, MazeModel, varargin{:});

    mazeMat = MazeModel.Matrix;
    sizeOfMazeMatrix = size(mazeMat);
    
    if ~p.Results.noFigure
        figure;
    end
    
    imagesc(flipud(mazeMat));
    set(gca,'YDir','normal');
    colormap('gray');
    pbaspect([sizeOfMazeMatrix(2) sizeOfMazeMatrix(1) 1]);
    
    if ~p.Results.mazeOnly
        
        if ~p.Results.noFigure
            figure;
        end
        
        for i = 1:length(MazeModel.Paths)

            p = MazeModel.Paths(i);
            indexShift =  i + i / 10;
            subplot(3,2,i)

            pm = p.Matrix;
            pm(pm == 1) = 0;
            visualPath = mazeMat + pm; 
            imagesc(visualPath);
            line([x1,x2],[y1,y2],'Color','r','LineWidth',2);
            xticks(linespace(0, sizeOfMazeMatrix(2)));
            yticks(linespace(0, sizeOfMazeMatrix(1)));
            pbaspect([sizeOfMazeMatrix(2) sizeOfMazeMatrix(1) 1]);
            set(gca,'FontSize',10);
            set(gca,'YDir','reverse');
            colormap('gray');
            title(['Path: ' p.Id] ); 
        end 
    end
end