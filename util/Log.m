function Log(logMessage)
%myFun - Description
%
% Syntax: Log(input)
%
% Long description
persistent FID
% Open the file
if strcmp(logMessage, 'open')
  FID = fopen(fullfile(tempdir, 'LogFile.txt'), 'w');
  if FID < 0
     error('Cannot open file');
  end
  return;
elseif strcmp(Data, 'close')
  fclose(FID);
  FID = -1;
end
fprintf(FID, '%s\n', logMessage);
% Write to the screen at the same time:
fprintf('%s\n', Data);
end