% eegplugin_mazelab() - EEGLAB plugin for handling maze data files.
%
% Usage:
%   >> eegplugin_mazelab(menu);
%   >> eegplugin_mazelab(menu, trystrs, catchstrs);
%
% Inputs:
%   menu       - [float]  EEGLAB menu handle
%   trystrs    - [struct] "try" strings for menu callbacks. See notes on EEGLab plugins.
%                (http://www.sccn.ucsd.edu/eeglab/contrib.html)
%   catchstrs  - [struct] "catch" strings for menu callbacks. See notes on EEGLab plugins.
%                (http://www.sccn.ucsd.edu/eeglab/contrib.html)
%
%
% Notes:
%   This plugins consist of the following Matlab files:
%   pop_loadmazes.m
%   load_maze.m
%
% Authors:
% Markus Fleck, Mobile Brain And Body Imagine Labor TU Berlin, August 2016
%

%123456789012345678901234567890123456789012345678901234567890123456789012

% Copyright (C) 2016 Markus Fleck, fleckmarkus.privat@gmail.com
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA


function vers = eegplugin_mazelab(fig, trystrs, catchstrs) 

    vers = 'mazelab0.0.1';

    if nargin < 3
        error('eegplugin_mazelab requires 3 arguments');
    end;

    % add folder to path
    % ------------------
    if ~exist('pop_loadmazes','file')
        p = which('eegplugin_mazelab.m');
        p = p(1:findstr(p,'eegplugin_mazelab.m')-1);
        addpath(genpath( p ));
    end;

    % Setup variables
    if ~exist('MAZES', 'var')
        disp('Setup MazeLab Variables...');
        
        MAZELAB.MAZES = [];
        MAZELAB.LASTIMPORT = '';
        assignin('base','MAZELAB', MAZELAB);
    end;

    
    % find import data menu
    % ---------------------
    menu = findobj(fig, 'tag', 'import data');

    % menu callbacks
    % --------------
    comcnt = [ trystrs.no_check '[ MAZELAB ] = pop_loadmaze( MAZELAB );' catchstrs.new_non_empty ];
    uimenu( menu, 'label', 'From .maze file', 'callback', comcnt, 'separator', 'on');
