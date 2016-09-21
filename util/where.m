
function [ out ] = where(source, selectFun)
% function: Shortcut for selecting with index and arrayfun
%
% Extended description

af = arrayfun(selectFun, source);

out = source(find(af));

end  % function
