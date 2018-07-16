function picNameList = getImgList()
current_dir = mfilename('fullpath');
idx = strfind(current_dir,'/');
folder = current_dir(1:idx(end));
folder = strcat(folder,'pictures/');
results = dir(folder);
isfile = ~[results.isdir]; 
picNameList = {results(isfile).name};


end

