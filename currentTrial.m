function [ fix_duration, mouse_x, mouse_y, fix_x, fix_y] = currentTrial(img, delay, filter, w, wRect)
try
    % Setup default aperture size.
    ms=200;
    
    % Fovea contains filtered image
    foveaimage = filterImage(img, filter);
    
    % Periphery contains original image
    peripheryimage = img;
    
    % Build texture for fovea
    foveatex=Screen('MakeTexture', w, foveaimage);
    tRect=Screen('Rect', foveatex);
    
    % Build texture for periphery
    nonfoveatex=Screen('MakeTexture', w, peripheryimage);
    [ctRect, dx, dy]=CenterRect(tRect, wRect);
    
    % Set cursor to center and hide it
    [a,b] = RectCenter(wRect);
    SetMouse(a,b,screenNumber);
    HideCursor;
    buttons = 0;
    
    % Make this program important
    %priorityLevel=MaxPriority(w);
    %Priority(priorityLevel);
    
    % Wait until all keys on keyboard are released:
    KbReleaseWait;
    
    % Init old mouse position
    mxold=0;
    myold=0;
    
    % Init fixation duration
    fix_duration = 0;
    
    % We create a two layers Luminance + Alpha matrix for use as transparency
    % (or mixing weights) mask: Layer 1 (Luminance) is filled with luminance
    % value 1.0 aka white - the ones() function does this nicely for us, by
    % first filling both layers with 1.0:
    [x,y] = meshgrid(-ms:ms, -ms:ms);
    maskblob = ones(2*ms+1, 2*ms+1, 2);
    
    % Layer 2 (Transparency aka Alpha) is now filled/overwritten with a gaussian
    % transparency/mixing mask.
    xsd = ms / 2.2;
    ysd = ms / 2.2;
    maskblob(:,:,2) = 1 - exp(-((x / xsd).^2) - ((y / ysd).^2));
    
    % Build a single transparency mask texture:
    masktex = Screen('MakeTexture', w, maskblob);
    
    % Show image
    imageTexture = Screen('MakeTexture', w, img);
    Screen('DrawTexture', w, imageTexture);
    Screen('Flip', w);
    
    % Init stillTime. stillTime is used to measure the time without
    % movement > distance threshold
    stillTime = 0;
    
    % Init vectors for mouse coordinates
    mouse_x = [];
    mouse_y = [];
    
    % Init vectors for fixation point coordinates
    fix_x = [];
    fix_y = [];
    
    % Init switch. If we already have an image blurred at the fixation
    % point, we only want to redraw it if there is a movement > distance
    % threshold. Otherwise, we want to stay the blur in place to record
    % seccadic movements
    isBlur = 0;
    while 1
        % Query current mouse cursor position
        [mx, my, buttons]=GetMouse;
        
        % Record mouse coordinates
        mouse_x(end+1) = mx;
        mouse_y(end+1) = my;
        
        % Calculate euclidean distance between old and new position
        dist = eDist(mxold, myold, mx, my)
        
        % We only want "big" movements to be considert a change of fixatoin
        % point. Smaller movements will be recorded as seccadic
        if dist > 15
            stillTime = 0; 
            isBlur = 0;
        else
            stillTime = stillTime + 0.001;
            if stillTime >= delay & isBlur == 0
                isBlur = 1;
                fix_x(end+1) = mx;
                fix_y(end+1) = my;
                myrect=[mx-ms my-ms mx+ms+1 my+ms+1];
                dRect = ClipRect(myrect,ctRect);
                sRect=OffsetRect(dRect, -dx, -dy);
                
                % Valid destination rectangle?
                if ~IsEmptyRect(dRect)
                    % Yes! Draw image for current frame:
                    
                    % Step 1: Draw the alpha-mask into the backbuffer. It
                    % defines the aperture for foveation: The center of gaze
                    % has zero alpha value. Alpha values increase with distance from
                    % center of gaze according to a gaussian function and
                    % approach 1.0 at the border of the aperture...
                    % Actual use of masktex to define transitions/mix:
                    
                    % First clear framebuffer to backgroundcolor, not using
                    % alpha blending (== GL_ONE, GL_ZERO), enable all channels
                    % for writing [1 1 1 1], so everything gets cleared to good
                    % starting values:
                    Screen('BlendFunction', w, GL_ONE, GL_ZERO, [1 1 1 1]);
                    Screen('FillRect', w, backgroundcolor);
                    
                    % Then keep alpha blending disabled and draw the mask
                    % texture, but *only* into the alpha channel. Don't touch
                    % the RGB color channels but use the channel mask
                    % [R G B A] = [0 0 0 1] to only enable the alpha-channel
                    % for drawing into it:
                    Screen('BlendFunction', w, GL_ONE, GL_ZERO, [0 0 0 1]);
                    Screen('DrawTexture', w, masktex, [], myrect);
                    
                    % Step 2: Draw peripheral image. It is only/increasingly drawn where
                    % the alpha-value in the backbuffer is 1.0 or close, leaving
                    % the foveated area (low or zero alpha values) alone:
                    % This is done by weighting each color value of each pixel
                    % with the corresponding alpha-value in the backbuffer
                    % (GL_DST_ALPHA). Disable alpha channel writes via [1 1 1 0], so
                    % alpha mask stays untouched and only RGB color channels are
                    % affected:
                    Screen('BlendFunction', w, GL_DST_ALPHA, GL_ZERO, [1 1 1 0]);
                    Screen('DrawTexture', w, nonfoveatex, [], ctRect);
                    % Step 3: Draw foveated image, but only/increasingly where the
                    % alpha-value in the backbuffer is zero or low: This is
                    % done by weighting each color value with one minus the
                    % corresponding alpha-value in the backbuffer
                    % (GL_ONE_MINUS_DST_ALPHA).
                    Screen('BlendFunction', w, GL_ONE_MINUS_DST_ALPHA, GL_ONE, [1 1 1 0]);
                    Screen('DrawTexture', w, foveatex, sRect, dRect);
                    Screen('Flip', w);
                end
            end
        end
        % Keep track of last gaze position:
        mxold=mx;
        myold=my;
        
        % We wait 1 ms each loop-iteration so that we
        % don't overload the system in realtime-priority:
        WaitSecs('YieldSecs', 0.001);
        
        % Abort demo on keypress our mouse-click:
        if KbCheck | find(buttons)
            break;
        end
    end
    
catch
    %this "catch" section executes in case of an error in the "try" section
    %above.  Importantly, it closes the onscreen window if its open.
    sca;
    ShowCursor;
    Priority(0);
    psychrethrow(psychlasterror);
end %try..catch..

% The same command which closes onscreen and offscreen windows also
% closes textures.
sca;
ShowCursor;
Priority(0);
return;

end