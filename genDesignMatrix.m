% function generating a design matrix
% c Daniel Nelle 2018

function designMatrix = genDesignMatrix(subjectNo, imgList)
%initialize random number generator
rng('shuffle');

%Factor filter
F1LevA = 1;
F1LevB = 2;

%Factor delay
F2LevA = 0.03;
F2LevB = 0.05;
F2LevC = 0.07;

F1 = [F1LevA, F1LevB];
F2 = [F2LevA, F2LevB, F2LevC];

NREP = length(imgList);
NTRIALS = length(F1) * length(F2) * NREP;

%preallocate an empty design matrix
design = NaN(NTRIALS, 5);

%%
ID = subjectNo;
cnt = 1;
for i = 1:length(F1)
    for j = 1:length(F2)
        for img = 0:NREP
            design(cnt, : ) = [0 ID F1(i) F2(j) img];
            cnt=cnt+1;
        end
    end
end

design = design(randperm(length(design)),:);
design(:,1) = 1:length(design);

designMatrix = design;



% %randomize trial order
% runningOrder = [Shuffle(1:36) Shuffle(37:72)];
% 
% runningOrder = [randperm(36) randperm(36)+36];
% 
% design = design(runningOrder,:)
% design(:,3) = 1:72



end
