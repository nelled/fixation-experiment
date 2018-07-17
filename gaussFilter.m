function [filtered_image] = gaussFilter(img)
N = 10;
sigma = 10;

[x, y] = meshgrid(round(-N/2):round(N/2), round(-N/2):round(N/2));
f = exp(-x.^2/(2 * sigma^2)-y.^2/(2 * sigma^2));
f = f ./ sum(f(:));

filtered_image = conv2(img, f, 'same');
end
