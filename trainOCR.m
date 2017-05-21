%Training & Group Loading File for OCR.
clear;
clc;
Training = [];
Group = [];
Sample = [];
a = 0;
x = 1;
y = 200;
w = 201;
h = 400;
% Generating Group for Classifier
for n = 1:62
    P = n*ones(5);
     P = P(:);
    Group = [Group; P];
end


%Loading The Root Folder
ImageFolder = dir('E:\CVPR_Dataset\English\Hnd\Img\Sample0**');

for i = 1 : 62 % Loop for Total 62 charecter (0-9),(A-Z)&(a-z)
   
    %Converting to string -> Root Folder Path 
    ImgFolder = strcat(ImageFolder(i).name);    
    ImageSrc = strcat('E:\CVPR_Dataset\English\Hnd\Img\',ImgFolder);   

    %Loading Images from Each Sub-Folder
    for ii = 1 : 25  % Loop for 9 Training Images for each letter
        
        filename = [ImageSrc, '\img0',num2str(i,'%02d'),'-0',num2str(ii,'%02d') '.png'];
        
        %Load Image....
        Image = ~im2bw(imresize(imread(filename), [800 800]));
        im = bwmorph(Image,'skel',Inf);
        
        %Cropping only the Letter Area from image.... 
        s = regionprops(im, 'BoundingBox');
        bb = round(reshape([s.BoundingBox], 4, []).');
        chars = cell(1, numel(s));
        for idx = 1 : numel(s)
            chars{idx} = im(bb(idx,2):bb(idx,2)+bb(idx,4)-1, bb(idx,1):bb(idx,1)+bb(idx,3)-1);
        end
        ch = chars{idx};
        I = imresize(ch, [400 400]);

        %Deviding into 4 equal parts.....
        a=I( x:y, x:y);  % (x:y, x:y) 
        b=I(w:h, x:y);  % (w:h, x:y)
        c=I(x:y, w:h);  % (x:y, w:h)
        d=I(w:h, w:h);  % (w:h, w:h)
        e=[sum(a(:)), sum(b(:)), sum(c(:)), sum(d(:))];
        % imshow(e);
        
        %Loading Training Data
        Training = [Training; e];
    end

end

%Saving Data to a File
save TrainingFile Training
save GroupFile Group

MSG = 'Loading and Saving Done! ';
disp(MSG);