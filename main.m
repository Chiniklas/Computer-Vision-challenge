% main
clear;
clc;
close all;
%% inputs for test
addpath('img')
Img = imread("simple-room.png");
n = 2;
%% Image Segmentation
% backgound is a rgb image
% foreground is a cell including n foreground objects 2D image
% fg2D is a cell containing all the 2D coordinates of the corner points of
% n foreground objects
patchsize = 9;
fillorder = "gradient";
[fg2D,foreground,background] = ImageSegment(Img,n,patchsize,fillorder);
% if foreground representation is not needed, you can comment the following
% codes
for i = 1:n
    figure;
    imshow(foreground{i});
end

%% Spidery mesh

[l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, OutterPoint,Updated_VanishingPoint,Updated_InnerRectangle] = spidery_mesh(background);
hold on


uiwait
%% generate 12 points
%  close the figure window to obtain 12 points matrix
%  size(TwelfPoints) = (2,12)

TwelfPoints_vp = gen12Points(Updated_VanishingPoint,Updated_InnerRectangle,OutterPoint);


%% add black outline

[image_pad, new_TwelfPoints_vp] = get_image_pad(background, TwelfPoints_vp);


%% plot 12 points

Img_pad = imread("input_image_pad.png");
imshow(Img_pad)
hold on

plot_2D_background(new_TwelfPoints_vp,Updated_InnerRectangle)
hold off

%% sperate 5 regions 

[leftwall, rearwall, rightwall, ceiling, floor] = image_matting(image_pad, new_TwelfPoints_vp);
%P should be [x y],instead of [x;y]
P1 = new_TwelfPoints_vp(:,1)';
P2 = new_TwelfPoints_vp(:,2)';
P3 = new_TwelfPoints_vp(:,3)';
P4 = new_TwelfPoints_vp(:,4)';
P5 = new_TwelfPoints_vp(:,5)';
P6 = new_TwelfPoints_vp(:,6)';
P7 = new_TwelfPoints_vp(:,7)';
P8 = new_TwelfPoints_vp(:,8)';
P9 = new_TwelfPoints_vp(:,9)';
P10 = new_TwelfPoints_vp(:,10)';
P11 = new_TwelfPoints_vp(:,11)';
P12 = new_TwelfPoints_vp(:,12)';
P13 = new_TwelfPoints_vp(:,13)';

%% perspective transform: get rectangles of 5 walls
outH = size(Img_pad,1);
outW = size(Img_pad,2);
leftwall_rec = Perspective_transform(leftwall, P11, P7, P5, P1, outH, outW);
rearwall_rec = Perspective_transform(rearwall, P7, P8, P1, P2, outH, outW);
rightwall_rec = Perspective_transform(rightwall, P8, P12, P2, P6, outH, outW);
ceiling_rec = Perspective_transform(ceiling, P9, P10, P7, P8, outH, outW);
floor_rec = Perspective_transform(floor, P1, P2, P3, P4, outH, outW);

%% 3D box construction
% real implementation
k = 0.55 * size(Img,1);

% the rear wall is red
% the ceiling is blue
% the floor is green
% the left wall is black
% the right wall is yellow

[TwelfPoints_3D,VanishingPoint_3D] = boxconstruction(new_TwelfPoints_vp,k);
% for testing, please run twelfPoints.m for simple extraction of 2D
% coordinatnions of the 12 Points
%twelfPoints = [P1',P2',P3',P4',P5',P6',P7',P8',P9',P10',P11',P12'];
%[twelfPoints_3D,vanishingpoint3d] = boxconstruction(vanishingpoint,twelfPoints);

%% foreground
focal_length =1 ;
d = (k-1) * focal_length;
imgsize = size(Img_pad);
[origin_image_pad, new_TwelfPoints_vp] = get_image_pad(Img, TwelfPoints_vp);
[fg3D, fg_polygon_function] = fg2Dto3D(n,origin_image_pad,new_TwelfPoints_vp,TwelfPoints_3D,k,d);
for i =1 :2
    plot_polygon(fg3D(:,4*i-3:4*i),fg_polygon_function(i),sprintf('fg%d.jpg',i));
    hold on 
end

% n is the number of the foregroundobjects
% fg3D size(3,4*n)
% fg_polygon_function n*1 system

