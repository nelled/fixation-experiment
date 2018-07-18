function [] = writeResult(jsonString, subjectNo)
% Writes json string to file.

    current_dir = mfilename('fullpath');
    idx=strfind(current_dir,'/');
    folder = current_dir(1:idx(end));
    folder = strcat(folder,'results/');
    
    % Make filename with timestamp
    fname = strcat(folder,int2str(subjectNo),'_', datestr(now,'HH:MM:SS'), '.json');
    
    % Write
    fid = fopen(fname,'wt');
    fprintf(fid, jsonString);
    fclose(fid);
end
