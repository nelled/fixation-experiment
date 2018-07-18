function image = loadImage(imageNo)
% Loads image given an integer indicating the image number.

    current_dir = mfilename('fullpath');
    idx=strfind(current_dir,'/');
    folder = current_dir(1:idx(end));
    folder = strcat(folder,'pictures/');
    imgNo = sprintf( '%03d', imageNo );
    imgName = strcat(imgNo,'.png');
    imagePath = strcat(folder,imgName);
    disp(imagePath);
    image=imread(imagePath);
end
