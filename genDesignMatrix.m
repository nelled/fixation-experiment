function designMatrix = genDesignMatrix(subjectNo, imgList)
% Generates a design matrix

%initialize random number generator
rng(100*subjectNo);

%Factor filter
F1LevA = 1;
F1LevB = 2;
F1LevC = 0;

%Factor delay
F2LevA = 0.3;
F2LevB = 0.5;
F2LevC = 0.7;

F1 = [F1LevA, F1LevB, F1LevC];
F2 = [F2LevA, F2LevB, F2LevC];

NREP = length(imgList);
NTRIALS = length(F1) * length(F2) * NREP;

% Preallocate an empty design matrix
design = NaN(NTRIALS, 5);

ID = subjectNo;
cnt = 1;
for i = 1:length(F1)
    for j = 1:length(F2)
        for img = 0:NREP-1
            design(cnt, : ) = [0 ID F1(i) F2(j) img];
            cnt=cnt+1;
        end
    end
end

design = design(randperm(length(design)),:);
design(:,1) = 1:length(design);

designMatrix = design;
end
