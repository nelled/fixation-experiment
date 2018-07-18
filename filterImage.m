function [filteredImage] = filterImage(img, filter)
% Filters the image passed as img according the filter identificator passed
% as filter. 1 = Gaussian, 2 = Laplacian, 0 = no filter.

% Convert image to double for further processing
img = double(img);
% Get red part
R = img(:, :, 1);
% Get green part
G = img(:, :, 2);
% Get the blue part
B = img(:, :, 3); 

% Filter each color separately 
if filter == 1
    R_fil = gaussFilter(R); 
    G_fil = gaussFilter(G); 
    B_fil = gaussFilter(B);
elseif filter == 2
    R_fil = laplacianFilter(R);
    G_fil = laplacianFilter(G);
    B_fil = laplacianFilter(B);
else
    % Do not filter
    R_fil = R;
    G_fil = G;
    B_fil = B;
end
filteredImage = uint8(cat(3, R_fil, G_fil, B_fil));
end
