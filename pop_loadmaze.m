function [ MAZELAB ] = pop_loadmaze( MAZELAB )
%POP_LOADMAZES Summary of this function goes here
%   Detailed explanation goes here

% ask user
[filename, filepath] = uigetfile('*.maze', 'Choose .maze files -- pop_loadmaze()');
drawnow;
if filename == 0 return; end;
MAZELAB.LASTIMPORT = load_maze([filepath filename]);
MAZELAB.MAZES = [ MAZELAB.MAZES MAZELAB.LASTIMPORT ] ;

end

