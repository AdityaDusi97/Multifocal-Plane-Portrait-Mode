close all
clear all

A = imread('Images/IMG_7590.png');
imshow(A);
F = griddedInterpolant(double(A));
[sx,sy,sz] = size(A);
% % upsample
% xq = (0:5/6:sx)';
% yq = (0:5/6:sy)';
% zq = (1:sz)';
% vq = uint8(F({xq,yq,zq}));
% figure
% imshow(vq)
% title('Higher Resolution')

% downsample
f1 = 3.245;
f2 = 3.24;
xq = (0:f1:sx)';
yq = (0:f2:sy)';
vq = uint16(F({xq,yq}));
%figure
%imshow(vq)
%title('Lower Resolution')