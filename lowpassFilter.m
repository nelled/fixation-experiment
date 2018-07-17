function [filtered_image] = lowpassFilter(img)
N = 20;
n=1;
d=50;
[x ~]=meshgrid(-floor(N/2):floor(N/2)-1,-floor(N/2):floor(N/2)-1);
% Define B
B = sqrt(2) - 1; 
% Define distance to centre
D = sqrt(x.^2 + y.^2); 
f = 1 ./ (1 + B * ((d ./ D).^(2 * n)));
filtered_image = conv2(img,f,'same');
end

