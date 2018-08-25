function picNameList = getImgList()
% Function reads pictures in directory and returns a list of filenames

currentDir = mfilename('fullpath');
idx = strfind(currentDir, '/');
folder = currentDir(1:idx(end));
folder = strcat(folder, 'pictures/');
results = dir(folder);
isfile = ~[results.isdir];
picNameList = {results(isfile).name};
end
