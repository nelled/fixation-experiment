function filteredImage = gaussFilter(img)
% Simple Gauss filter, N and sigma are chosen arbitrarily

N = 10;
sigma = 10;

[x, y] = meshgrid(round(-N/2):round(N/2), round(-N/2):round(N/2));
f = exp(-x.^2/(2 * sigma^2)-y.^2/(2 * sigma^2));
f = f ./ sum(f(:));

filteredImage = conv2(img, f, 'same');
end
