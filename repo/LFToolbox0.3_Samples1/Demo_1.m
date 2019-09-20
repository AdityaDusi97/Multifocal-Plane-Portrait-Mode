% 
% For single subject
%

close all
clear all

%%
% Decoded File path
% 
fName = fullfile('Images','IMG_7580__Decoded.mat');

%Load up a light field
fprintf('Loading %s...', fName);
load(fName,'LF');
fprintf(' Done\n');
LFSize = size(LF);

% Gamma correct just for displaying purpose
LF = im2double(LF);
LF = LF.^0.5;

% use the display functions from the toolbox
CurFigure = 1;
LFFigure(CurFigure);
CurFigure = CurFigure + 1;
LFDisp(LF);
axis image off
truesize
title('Input');
drawnow

%% Normal Shift and Add operation
% This is a sweep over the focal stack
% NEGATIVE slopes focus at closer distances
focal_stack = zeros(LFSize(3),LFSize(4),10);
Slope = -1/9;
fprintf('Applying shift sum filter');
[ShiftImg1, FiltOptionsOut] = LFFiltShiftSum( LF, Slope );
fprintf(' Done\n');
FiltOptionsOut

LFFigure(CurFigure); 
CurFigure = CurFigure + 1;
LFDisp(ShiftImg1);
axis image off
truesize
title(sprintf('Shift sum filter, slope %.3g', Slope));
drawnow

%% let's now use the depth map
depth = im2double(imread('Images/IMG_7580.png'));
% imtool(depth); this is to analyse stuff
I = depth;
I = downsample_self(I);
I = 1-I; % flip the numbers
figure, imshow(I);
imtool(I);

num_partitions = 4; % 5 partitions
num_classes = num_partitions + 1;
level = multithresh(I,num_partitions);
seg_I = imquantize(I,level);
figure;
imshow(seg_I,[]), title('Thresholded');

% person mask. Pick the max value from segmentation
temp = seg_I;
temp(~(temp==num_classes))=0;
temp(temp==num_classes)=1;
figure,imshow(temp), title('Segmentation Mask');
m1 =temp;
 
f1 = m1.*ShiftImg1(:,:,1:3);
figure, imshow(f1);
%% Applying depth dependent blur based on depth map
m3 = m1;
m3 = 1-m3;
figure, imshow(m3);
im = ShiftImg1;
Kernel_size = 7;
blur_im = depth_dep_blur(im, seg_I, num_classes, Kernel_size);
figure, imshow(blur_im); title('Blurred Image')
im_sharp = m1.*ShiftImg1; %+ m2.*ShiftImg2;

im_sharp = im_sharp(:,:,1:3) + m3.*blur_im;
figure, imshow(im_sharp);

%% Improving the saturation
HSV = rgb2hsv(im_sharp);
% "20% more" saturation:
HSV(:, :, 2) = HSV(:, :, 2) * 1.6;
HSV(:, :, 3) = HSV(:, :, 3) * 1.3;
HSV(HSV > 1) = 1;  % Limit values
im_sharp = hsv2rgb(HSV);
figure, imshow(im_sharp), title('Portrait Mode');
