classdef EEGLabExt
   methods(Static)
      function Check( EEG, varargin )
        ignoreUrEvents = 0;

        if length(varargin) > 0
            nVarargs = length(varargin);
            for k = 1:nVarargs
                if strfind(varargin{k}, 'ignoreUrevents')
                        ignoreUrEvents = 1;
                end 
            end
        end;

        if ~isstruct(EEG)
            error('first argument must be an EEG dataset structure');
        end

        if ~isfield(EEG,'event')
           error('No EEG.event structure found');
        end

        
        if ~ignoreUrEvents & ~isfield(EEG.event,'urevent')
          error('No EEG.event().urevent field found');
        end
      end;
    end
end