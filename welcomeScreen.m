function [] = welcomeScreen(subjectNo, w, wRect)


% Get center
[xCenter, yCenter] = RectCenter(wRect);

% Initialize text strings
message = sprintf('Welcome to the fixation experiment.\nYour subject number is %d.\nYou will be shown pictures in random order.\nOn fixation points, a filter will be applied.\nYour eye movement will be recorded.', subjectNo);

% Draw
% Draw text in the middle of the screen in Courier in white
Screen('TextSize', w, 60);
Screen('TextFont', w, 'Arial');
DrawFormattedText(w, message, xCenter-xCenter/2, yCenter, [1 1 1]);

Screen('Flip', w);

% Wait for mouseclick:
GetClicks;

end
