function [filtered_image] = filterImage(img, filter)
img = double(img);
if filter == 'gauss'
    R = img(:,:,1); %get the Red part
    G = img(:,:,2); %get the Blue part
    B = img(:,:,3); %get the Green part
    R_gauss = gaussFilter(R); %write your own function name
    G_gauss = gaussFilter(G); %or repeat the code by REPLACING I as 
    B_gauss = gaussFilter(B); %Red Green Blue components
    filtered_image = uint8(cat(3,R_gauss, G_gauss, B_gauss));
end

end

