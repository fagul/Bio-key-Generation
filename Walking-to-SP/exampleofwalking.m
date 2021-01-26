% An example for using walking algorithm to detect singular points in
% fingerprint image. 
% Note that the open souce code "MATLAB and Octave Functions for Computer 
% Vision and Image Processing" is needed to correctly run the walking
% algorithm. Please download "MatlabFns.zip" from 
%           http://www.peterkovesi.com/matlabfns/
% and add all the folders and subfolders to Path.
%
% % Coded by Xifeng Guo. All rights reserved. 2015/11/29 % %
%
%% Read image and set groundtruth
im = imread('101_1.tif');
% groundtruthsp.core=[183   148;   184   182];
% groundtruthsp.delta=[116   251;   286   278];


%% Detect singular points of image \im using walking algorithm
% 1. first example for usage of walking.
%detectedsp1 = walking(im);

% % 2. second example for usage of walking.
% % 2.1 normalization and segmentation
% blksze = 16; thresh = 0.3;
% [normim, mask] = ridgesegment(im, blksze, thresh);
% mask(floor(size(mask,1)/blksze)*blksze+1:size(mask,1),:)=0;
% mask(:,floor(size(mask,2)/blksze)*blksze+1:size(mask,2))=0;
% mask = imopen(mask, strel('square',2*blksze));
% % 2.2 orientation field estimation
% orientim = ridgeorient(normim, 1, 3,3);
% orientim  = pi - orientim;
% % 2.3 detect singular points by giving foreground mask and orientation
% % field.
% detectedsp2 = walking(im, mask, orientim);

% 3. third example for usage of walking.
% 3.1 normalization and segmentation
blksze = 16; thresh = 0.3;
[normim, mask] = ridgesegment(im, blksze, thresh);
mask(floor(size(mask,1)/blksze)*blksze+1:size(mask,1),:)=0;
mask(:,floor(size(mask,2)/blksze)*blksze+1:size(mask,2))=0;
mask = imopen(mask, strel('square',2*blksze));
% 3.2 orientation field estimation
orientim = ridgeorient(normim, 1, 3,3);
orientim  = pi - orientim;
% 3.3 detect singular points by giving step lenth and number of starting
% points
detectedsp3 = walking(im, mask, orientim, 7, 2);

%% mark singular points on the image
imshow(im); hold on;
% % groundtruth
% plot(groundtruthsp.core(:,1), groundtruthsp.core(:,2), 'or', 'markersize',10,'linewidth',2);
% plot(groundtruthsp.delta(:,1), groundtruthsp.delta(:,2), '^r', 'markersize',10, 'linewidth' ,2);
%detected
detectedsp = detectedsp3;
plot(detectedsp3.core(:,1), detectedsp3.core(:,2), 'go', 'markersize',12,'linewidth',2);
% plot(detectedsp3.delta(:,1), detectedsp3.delta(:,2), 'g^', 'markersize',12, 'linewidth' ,2);
% leg = legend('Groundtruth core','Groundtruth delta', 'Detected core','Detected delta');
% set(leg,'location','southwest');

