function subjectNo = getCurrentSubjectNo()
currentDir = mfilename('fullpath');
idx = strfind(currentDir, '/');
folder = currentDir(1:idx(end));
folder = strcat(folder, 'results/');
results = dir(folder);
isfile = ~[results.isdir];
filenames = {results(isfile).name};
if isempty(filenames)
    subjectNo = 1;
else
    nums = cellfun(@(x) strsplit(x, '_'), filenames, 'UniformOutput', false);
    nums = cat(1, nums{:});
    nums = nums(:, 1);
    nums_vec = [];
    for k = 1:length(nums)
        nums_vec = [nums_vec, str2num(nums{k})];
    end
    subjectNo = max(nums_vec) + 1;
end

end
