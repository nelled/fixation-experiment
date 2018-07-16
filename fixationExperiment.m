% Setup
% Set default vaules. Will not work without it for some reason.
PsychDefaultSetup(2);

% Set background color to black
backgroundcolor = 0.0;

% Get the list of screens and choose the one with the highest screen number.
screenNumber=max(Screen('Screens'))

% Create fullscreen window with 0 - 0.1 color range
[w, wRect] = PsychImaging('OpenWindow', screenNumber, backgroundcolor);

% Get subject No
subjectNo = getCurrentSubjectNo;

% Get image list
images = getImgList();

% Generate design matrix
designMatrix = genDesignMatrix(subjectNo, images);

% Diplay welcome screen
welcomeScreen(subjectNo, w, wRect);





sca;


% current_dir = mfilename('fullpath');
% idx=strfind(current_dir,'/');
% folder = current_dir(1:idx(end));
% folder = strcat(folder,'pictures/');
% image = strcat(folder,'000.png');
% imdata=imread(image);
% 
% images = getImgList;
% 
% 
% genDesignMatrix(1, images)

% Show welcome Screen
% Iterate over design matrix
% % Assemble file name, load picture
% save, probably as json because of the coordinates



%[a,b,c,d,e] = currentTrial(imdata, 0.1, 'gauss', w, wRect);

%plot(b,c,d,e, 'rs')