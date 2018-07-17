function [] = writeREsult(jsonString)
current_dir = mfilename('fullpath');
idx=strfind(current_dir,'/');
folder = current_dir(1:idx(end));
folder = strcat(folder,'results/');

end

