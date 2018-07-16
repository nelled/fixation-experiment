function [ cropped_image ] = cropImage(image, window)
% Crops image to make it fit the size of the window provided as argument.

[iy, ix, ~] = size(image);
[wW, wH] = WindowSize(window);
if ix > wW
    cl = round((ix - wW) / 2);
    cr = (ix - wW) - cl;
else
    cl = 0;
    cr = 0;
end
if iy > wH
    ct = round((iy - wH) / 2);
    cb=(iy - wH) - ct;
else
    ct = 0;
    cb = 0;
end

% Crop image
cropped_image = image(1 + ct:iy - cb, 1 + cl:ix - cr, :);

end
