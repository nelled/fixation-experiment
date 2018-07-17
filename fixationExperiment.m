try
    % Setup
    % Set default vaules. Will not work without it for some reason.
    PsychDefaultSetup(2);
    
    % Set background color to black
    backgroundcolor = 0.0;
    
    % Get the list of screens and choose the one with the highest screen number.
    screenNumber = max(Screen('Screens'));
    
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
    
    % Init json
    result = sprintf('{"subjectNo" : "%d", "trials"  : [', subjectNo);
    
    % Loop over trials
    for trial = 1:size(designMatrix, 1)
        
        % Assign vals
        filter = designMatrix(trial,3);
        delay = designMatrix(trial,4);
        imageNo = designMatrix(trial,5);
        
        % Load image from image number
        image = loadImage(imageNo);
        % Run trial
        [fixDurations, mouseX, mouseY, fixX, fixY] = currentTrial(image, delay, filter, w, wRect, screenNumber, backgroundcolor);
        % Make json string for trial
        trialJson = trialToJson(trial, delay, filter, imageNo, fixDurations, mouseX, mouseY, fixX, fixY);
        % Append trial to result json
        result = [result, [trialJson ',']];
    end
    % Truncate last comma and append closing brackets
    result = [result(1:end-1), ']}']
    writeResult(result,subjectNo);
    sca;
catch
    sca;
    ShowCursor;
    Priority(0);
    psychrethrow(psychlasterror);
end


%plot(b,c,d,e, 'rs')