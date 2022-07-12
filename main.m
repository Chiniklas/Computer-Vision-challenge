% main
clear;

%% inputs for test

Img = imread("oil-painting.png");
n =1;
%% Spidery mesh

[l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,OutterPoint] = spidery_mesh(Img);
hold on


uiwait
%% generate 12 pointsc
%  close the figure window to obtain 12 points matrix
%  size(TwelfPoints) = (2,12)

TwelfPoints = gen12Points(Updated_VanishingPoint,Updated_InnerRectangle,OutterPoint);


%% add black outline

[image_pad, new_TwelfPoints] = get_image_pad(Img, TwelfPoints);


%% plot 12 points

Img_pad = imread("input_image_pad.png");
imshow(Img_pad)
hold on

plot(new_TwelfPoints(1,:),new_TwelfPoints(2,:),'rO')





%% foreground
[fg3D fg_polygon_function] = fg2Dto3D(n,image_pad,TwelfPoints);
% n is the number of the foregroundobjects
% fg3D size(3,4*n)
% fg_polygon_function n*1 system

