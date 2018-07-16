N = 20;
n=1;
d=50;
[x y]=meshgrid(-floor(N/2):floor(N/2)-1,-floor(N/2):floor(N/2)-1);
B = sqrt(2) - 1; %// Define B
D = sqrt(x.^2 + y.^2); %// Define distance to centre
hhp = 1 ./ (1 + B * ((d ./ D).^(2 * n)));
imagesc(1-hhp)