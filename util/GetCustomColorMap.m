function cm = GetCustomColorMap(varargin)

    defaultBounds = [1 0 1; 0 1 0];
    defaultColorCount = 2;
    p = inputParser;
    addOptional(p, 'colorBounds', defaultBounds)
    addOptional(p, 'colorCount', defaultColorCount);
    
    
    availableZeroModes = {'bottom' 'mid'};
    errorMessage = 'Zero Mode coud be only "mid" or "bottom"';
    validZeroMode = @(x) assert(ischar(x) && any(ismember(availableZeroModes, x)), errorMessage);
    addOptional(p, 'zeroPosition', availableZeroModes{1}, validZeroMode);
    
    parse(p, varargin{:});
    
    colorBounds = p.Results.colorBounds;
    colorCount = p.Results.colorCount;
    
    colorSpaceAsHSV = rgb2hsv(colorBounds);
    
    interpolatedColorSpace = interp1([0 colorCount], colorSpaceAsHSV(:,1), 1:colorCount);
    
    colorSpaceAsHSV = [interpolatedColorSpace(:), repmat(colorSpaceAsHSV(2:3), colorCount, 1)];
    
    cm = hsv2rgb(colorSpaceAsHSV);

    s = size(cm);
    halfOfCm = s(1)/2;
    
    lowerValues = cm(1:halfOfCm,1:end);
    
    upperValues = cm(halfOfCm:end, 1:end);
    
    if strcmp(p.Results.zeroPosition, availableZeroModes{1})
        cm = [1 1 1; lowerValues; upperValues];
    else
        cm = [lowerValues; 1 1 1; upperValues];
    end
end