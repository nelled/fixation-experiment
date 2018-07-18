function filteredImage = laplacianFilter(img)
% Simple laplacian filter, change the middle value for different results.
    middle = 5;
    filter = [0 -1 0 ; -1 middle -1 ; 0 -1 0];
    filteredImage = conv2(img, filter, 'same');
end
