function PlotAsImageSc(MazeModel)

    mazeMat = MazeModel.Matrix;

    figure;
    imagesc(mazeMat);
    colormap('gray');

    figure;

    for i = 1:length(MazeModel.Paths)
        
        p = MazeModel.Paths(i);

        subplot(3,2,i)
        
        pm = p.Matrix;
        pm(pm == 1) = 0;
        visualPath = mazeMat + pm; 
        imagesc(visualPath);
        set(gca,'FontSize',12)
        set(gca,'YDir','reverse')
        colormap('gray');
        title(['Path: ' p.Id] ); 
    end 
end