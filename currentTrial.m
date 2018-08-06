function [mouse_x, mouse_y, fix_x, fix_y] = currentTrial(img, delay, filter, w, wRect, screenNumber, backgroundcolor)
try
    % Setup default aperture size.
    ms = 200;
    
    % Fovea contains filtered image
    foveaimage = filterImage(img, filter);
    
    % Periphery contains original image
    peripheryimage = img;
    
    % Build texture for fovea
    foveatex = Screen('MakeTexture', w, foveaimage);
    tRect = Screen('Rect', foveatex);
    
    % Build texture for periphery
    nonfoveatex = Screen('MakeTexture', w, peripheryimage);
    [ctRect, dx, dy] = CenterRect(tRect, wRect);
    
    % Set cursor to center and hide it
    [a, b] = RectCenter(wRect);
    SetMouse(a, b, screenNumber);
    HideCursor;
    buttons = 0;
    
    % Make this program important
    priorityLevel=MaxPriority(w);
    Priority(priorityLevel);
    
    % Wait until all keys on keyboard are released:
    KbReleaseWait;
    
    % Init old mouse position
    mxold = 0;
    myold = 0;
    
    % Create luminance and alpha matrix as a mask to blend the filtered and
    % the original image into each other
    [x, y] = meshgrid(-ms:ms, -ms:ms);
    maskblob = ones(2*ms+1, 2*ms+1, 2);
    
    % Fill alpha layer with gaussian
    xsd = ms / 2.2;
    ysd = ms / 2.2;
    maskblob(:, :, 2) = 1 - exp(-((x / xsd).^2)-((y / ysd).^2));
    
    % Build a single transparency mask texture:
    masktex = Screen('MakeTexture', w, maskblob);
    
    % Show image
    imageTexture = Screen('MakeTexture', w, img);
    Screen('DrawTexture', w, imageTexture);
    
    % Get timestamp of first show
    t0 = Screen('Flip', w);
    
    % Init stillTime. stillTime is used to measure the time without
    % movement > distance threshold
    stillTime = 0;
    
    % Init vectors for mouse coordinates
    mouse_x = [];
    mouse_y = [];
    
    % Init vectors for fixation point coordinates
    fix_x = [];
    fix_y = [];
    
    % Init flag. If we already have an image blurred at the fixation
    % point, we only want to redraw it if there is a movement > distance
    % threshold. Otherwise, we want to stay the blur in place to record
    % seccadic movements.
    isFiltered = 0;

    while 1
        % Query current mouse cursor position
        [mx, my, buttons] = GetMouse;
        
        % Record mouse coordinates
        mouse_x(end+1) = mx;
        mouse_y(end+1) = my;
        
        % Calculate euclidean distance between old and new position
        dist = eDist(mxold, myold, mx, my);
        
        % We only want "big" movements to be considered a change of fixation
        % point. Smaller movements will be recorded as seccadic
        if dist > 15
            stillTime = 0;
            % Check if already filtered
            isFiltered = 0;
            
            % Clear everything
            Screen('BlendFunction', w, GL_ONE, GL_ZERO, [1, 1, 1, 1]);
            Screen('FillRect', w, backgroundcolor);
            
            % Draw
            Screen('DrawTexture', w, nonfoveatex, [], ctRect);
            
            % Flip
            t0Still = Screen('Flip', w);
        else
            % Check if we already exceeded delay
            tStill = GetSecs() - t0Still;
            if tStill >= delay && isFiltered == 0
                
                % Set flag
                isFiltered = 1;
                
                % Append coordinates
                fix_x(end+1) = mx;
                fix_y(end+1) = my;
                
                % Define area to be filtered
                myrect = [mx - ms, my - ms, mx + ms + 1, my + ms + 1];
                
                % Clip accordingly
                dRect = ClipRect(myrect, ctRect);
                sRect = OffsetRect(dRect, -dx, -dy);
                
                % Valid destination?
                if ~IsEmptyRect(dRect)
                    % Draw alpha mask. Opacity is zero at the center of our
                    % aperture. It increases according to the gaussian
                    % function until it reaches 1 (full opacity)

                    % Clear everything to background color, not using
                    % blending [1, 1, 1, 1] means RGBA channels.
                    Screen('BlendFunction', w, GL_ONE, GL_ZERO, [1, 1, 1, 1]);
                    Screen('FillRect', w, backgroundcolor);
                    
                    % Still no blending, draw mask into alpha channel.
                    Screen('BlendFunction', w, GL_ONE, GL_ZERO, [0, 0, 0, 1]);
                    Screen('DrawTexture', w, masktex, [], myrect);
                    
                    % Draw non filtered image. It is drawn according to the
                    % alpha value (GL_DST_ALPHA constant). Alpha mask is
                    % not modified because now we only write to RGB
                    % [1,1,1,0]
                    Screen('BlendFunction', w, GL_DST_ALPHA, GL_ZERO, [1, 1, 1, 0]);
                    Screen('DrawTexture', w, nonfoveatex, [], ctRect);
                    
                    % Draw filtered image, but with inverted alpha value,
                    % meaning that we draw where we did not draw before
                    % (GL_ONE_MINUS_DST_ALPHA constant). Again only write
                    % to RGB.
                    Screen('BlendFunction', w, GL_ONE_MINUS_DST_ALPHA, GL_ONE, [1, 1, 1, 0]);
                    Screen('DrawTexture', w, foveatex, sRect, dRect);
                    
                    % Display
                    Screen('Flip', w);
                end
            end
        end
        % Keep track of last eye position:
        mxold = mx;
        myold = my;
        
        % We wait 1 ms each loop-iteration so that we
        % don't overload the system in realtime-priority:
        WaitSecs('YieldSecs', 0.001);
        
        % Break if time elapsed from first display is >= 5.
        if GetSecs() - t0 >= 5.0
            break;
        end
        % Abort keypress or mouse-click
        if KbCheck | find(buttons)
            break;
        end
    end
    
catch
    % Recover from exception
    sca;
    ShowCursor;
    Priority(0);
    psychrethrow(psychlasterror);

%try..catch..
end 

% Close textures so they do not linger in memory
Screen('Close', foveatex);
Screen('Close', nonfoveatex);
Screen('Close', masktex);
return;

end
