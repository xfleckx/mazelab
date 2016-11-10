function kernel = GetKernelFor(unitCode)

% 0 0 0 0 = 0
% 1 1 1 1 = 15
% 1 0 0 0 = 1 % Westen 
% 0 0 0 1 = 8 % Osten
% 1 0 0 1 = 9 % Westen Osten
% 0 0 1 0 = 4 % Norden
% 1 0 1 0 = 5 % Westen Norden
% 0 1 0 0 = 2 % S�den
    
    kernel = zeros(4,4);
    
    if unitCode == 2
        kernel = [ ...
                0 0 0 0 ; ...
                0 1 1 0 ; ...
                0 1 1 0 ; ...
                0 1 1 0 ];
    end
    
    
    if unitCode == 4
        kernel = [ ...
                0 1 1 0 ; ...
                0 1 1 0 ; ...
                0 1 1 0 ; ...
                0 0 0 0 ];
    end
    
    if unitCode == 5
        kernel = [ ...
                0 1 1 0; ...
                1 1 1 0 ; ...
                1 1 1 0 ; ...
                0 0 0 0 ];
    end
    
    if unitCode == 8
        kernel = [ ...
                0 0 0 0 ; ...
                0 1 1 1 ; ...
                0 1 1 1 ; ...
                0 0 0 0];
    end
    
    
    if unitCode == 9
        kernel = [ ...
                0 0 0 0; ...
                1 1 1 1; ...
                1 1 1 1; ...
                0 0 0 0 ];
    end
    
    return;
end
