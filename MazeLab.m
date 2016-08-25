classdef MazeLab
   methods(Static)
      function Check( MAZELAB )
          if ~isstruct(MAZELAB)
            error('MAZELAB argument must be an MAZELAB dataset structure');
          end

          if ~isfield(MAZELAB, 'MAZES')
              error('MAZELAB parameter should contain the MAZES field');
          end;
      end;
    end
end