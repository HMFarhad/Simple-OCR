%Simple Optical Charecter Recognition for Handwritten Charecter.
clc;
importTraining = load('TrainingFile'); % Importing the Training data
Training = importTraining.Training;    % Loading Training data to an Array

importGroup = load('GroupFile');       % Importing the Group data
Group = importGroup.Group;             % Loading Group data to an Array
x = 1;
y = 200;
w = 201;
h = 400;

%Loading The Root Folder
ImageFolder = dir('E:\CVPR_Dataset\English\Hnd\Img\Sample0**');

for q = 8:12  % Sample portion loop, contains 7,8,9,A,B
    
    %Converting to string -> Root Folder Path 
    ImgFolder = strcat(ImageFolder(q).name);
    ImageSrc = strcat('E:\CVPR_Dataset\English\Hnd\Img\',ImgFolder);
    filename = [ImageSrc, '\img0',num2str(q,'%02d'),'-026.png'];  %Loads 26 No image as a Sample for each. 
    %Load Image
    Image = ~im2bw(imresize(imread(filename), [800 800]));
    %Image = ~im2bw(imresize(imread('E:\CVPR_Dataset\English\Hnd\Img\Sample002\img002-011.png'), [800 800]));
    
    %Cropping only the Letter Area from image.... 
    im = bwmorph(Image,'skel',Inf);
    s = regionprops(im, 'BoundingBox');
    bb = round(reshape([s.BoundingBox], 4, []).');
    chars = cell(1, numel(s));
    for idx = 1 : numel(s)
        chars{idx} = im(bb(idx,2):bb(idx,2)+bb(idx,4)-1, bb(idx,1):bb(idx,1)+bb(idx,3)-1);
    end
    ch = chars{idx};
    I = imresize(ch, [400 400]);

    %Deviding Cropped Image into 4 equal parts.....
    a=I( x:y, x:y);  % (x:y, x:y) 
    b=I(w:h, x:y);  % (w:h, x:y)
    c=I(x:y, w:h);  % (x:y, w:h)
    d=I(w:h, w:h);  % (w:h, w:h)
    % e=[a, c; b, d];
    % imshow(e);
    
    %Loading Sample Data
    Sample = [sum(a(:)), sum(b(:)), sum(c(:)), sum(d(:))];

    % KNN Classifier..........
    Class = knnclassify(Sample, Training, Group);
    %disp(Class);
    
    %Displaying the Result...........
    if(Class== 1)
        MSG =  strcat('The Letter is :0');
        disp(MSG);
    elseif(Class <= 10)
        MSG =  strcat('The Letter is : ', num2str(Class-1));
        disp(MSG);
    else 
        letter = char(Class + 54);
        MSG =  strcat('The Letter is : ', letter);
        disp(MSG);
    end
        
end