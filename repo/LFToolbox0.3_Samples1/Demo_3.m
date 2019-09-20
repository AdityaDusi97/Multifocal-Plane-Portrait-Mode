% 
% Demo 3
% It does that based on inbuild functions and using some heuristics from
% the user.
%

clear all
close all


%%
% Decoded File path
fName = fullfile('Images','IMG_7614__Decoded.mat');

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
Slope = 0;
fprintf('Applying shift sum filter');
tic
[ShiftImg2, FiltOptionsOut] = LFFiltShiftSum( LF, Slope );
y=toc;
fprintf(' Done\n');
FiltOptionsOut

LFFigure(CurFigure); 
CurFigure = CurFigure + 1;
LFDisp(ShiftImg2);
axis image off
truesize
title(sprintf('Shift sum filter, slope %.3g', Slope));
drawnow

Slope = -3/9;
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

%% Load the depth map
% why am I doing this? I already have people in focus
tic,
depth = im2double(imread('Images/IMG_7614.png'));

I = depth;
I = downsample_self(I);
I = 1-I; % flip the numbers
figure, imshow(I);
imtool(I);

%% Multi-level threshold for segmentation
% this is using lytro's depth map
num_partitions = 4; % 4 partitions 
num_classes = num_partitions + 1;
level = multithresh(I,num_partitions);
seg_I = imquantize(I,level);
%RGB = label2rgb(seg_I); 
figure;
imshow(seg_I,[]);

%% New function to segment people based on the depth map.
% This doesn't affect how the blurring is done
h1 = 2; % heuristic for person. Using the max 2
h2 = 1; % just use one level for the first person
[m1,m2] = segment_p(h1,h2,seg_I, num_classes);

%% downsample the mask to the same size as the image
f1 = m1.*ShiftImg2(:,:,1:3);
f2 = m2.*ShiftImg1(:,:,1:3);
figure, 
sgtitle('Downsample masks')
subplot(2,2,1), imshow(m1); title('Mask 1')
subplot(2,2,2), imshow(m2); title('Mask 2')
subplot(2,2,3), imshow(f1); title('Application of the mask')
subplot(2,2,4), imshow(f2); title('Application of the mask')

%% Applying depth dependent blur based on depth map
% let's apply raw blurring on the image and we can later take care of using
% masks to make sure we don't blur the subject behind.
% combine both the masks
m3 = or(m1,m2);
m3 = 1-m3;
figure, imshow(m3);
im = ShiftImg1;
Kernel_size = 7;
blur_im = depth_dep_blur(im, seg_I, num_classes, Kernel_size);
figure, imshow(blur_im); title('Blurred Image')
im_sharp = m1.*ShiftImg1 + m2.*ShiftImg2;

im_sharp = im_sharp(:,:,1:3) + m3.*blur_im;
figure, imshow(im_sharp);

%% Improving the saturation
HSV = rgb2hsv(im_sharp);
% "20% more" saturation:
HSV(:, :, 2) = HSV(:, :, 2) * 1.5;
HSV(:, :, 3) = HSV(:, :, 3) * 1.5;
HSV(HSV > 1) = 1;  % Limit values
im_sharp = hsv2rgb(HSV);
figure, imshow(im_sharp), title('Portrait Mode');
t = toc;