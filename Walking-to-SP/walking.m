% The main function of the walking algorithm to get all singular points in 
% a given fingerprint image.
%
% Based on the paper:
%
% @article{Zhu2016WalkingTS,
%   title={Walking to singular points of fingerprints},
%   author={En Zhu and Xifeng Guo and Jianping Yin},
%   journal={Pattern Recognition},
%   year={2016},
%   volume={56},
%   pages={116-128}
% }
%
% Usage:
%   [sps, time] = walking(im), get singular points of image \im. The open 
%   souce code "MATLAB and Octave Functions for Computer Vision and Image 
%   Processing" is needed to correctly run this function. Please download 
%   "MatlabFns.zip" from 
%           http://www.peterkovesi.com/matlabfns/
%   and add all the folders and subfolders to Path.
% 
%   [sps, time] = walking(im, mask, orientim), all preprocessing steps like
%   segmentaion and orientation field estimation are implemented outside
%   this function.
%
%   [sps, time] = walking(im, mask, orientim, ...), parameters are passed
%   in. The detailed meanings of parameters are shown below.
% 
% @Inputs:
%   im: 
%       image data, h by w
%   mask:
%       0, background; 1, foreground
%   orientim:
%       pixel-wise orientation field of \im, share the same size with \im.
%   step:
%       length of one walking step, default to 7 pixel
%   n:
%       number of starting points sampled along x-axis or y, default to 2
%   Td:
%       threshold for stopping the walking process, default to 2 pixel
%   R:
%       radius of the neighborhood of the candidate singular point,
%       default to 16 pixel
% @Outputs:
%   sps:
%       a structure with fields 'core' and 'delta', containing the detected 
%       singular points
%   time:
%       processing time of the walking algorithm excluding the segmentation
%       and orientation field estimation.
%
% % Coded by Xifeng Guo. All rights reserved. 2015/4/16 % %
%
function [sps, time] = walking(im, mask, orientim, step, n, Td, R)
%% arguments initialization
sps.core = [];  sps.delta = [];
if nargin < 3
    % The \mask and \orientim are computed using the open souce code 
    % "MATLAB and Octave Functions for Computer Vision and Image Processing" .
    % Please download "MatlabFns.zip" from 
    %           http://www.peterkovesi.com/matlabfns/
    % and add all the folders and subfolders to Path.
    % It is absolutely possible to use other segmentation and orientation
    % field estimation methods to compute \mask and \orientim.
    
    % Identify ridge-like regions and normalise image
    blksze = 16; thresh = 0.3;
    [normim, mask] = ridgesegment(im, blksze, thresh);
    % reset last rows and column to 0
    mask(floor(size(mask,1)/blksze)*blksze+1:size(mask,1),:)=0;
    mask(:,floor(size(mask,2)/blksze)*blksze+1:size(mask,2))=0;
    mask = imopen(mask, strel('square',2*blksze));
    
    % Determine ridge orientations
    orientim = ridgeorient(normim, 1, 3,3);
    orientim  = pi - orientim;
end
if nargin < 4; step = 7; end
if nargin < 5; n = 2; end
if nargin < 6; Td = 2; end
if nargin < 7; R = 16; end

%% detect singular points
ti = tic; % record the processing time

% Sampling starting points
[I,J] = find(mask == 1);
edge0 = min([I,J]); % the upper left corner of the bounding box of foreground
edge1 = max([I,J]); % the lower right corner of the bounding box of foreground
d = floor((edge1 - edge0)/(n+1)); % sampling step length along x- and y-coordinate
sampled_rows = edge0(1)+d(1):d(1):edge0(1)+d(1)*n;
sampled_cols = edge0(2)+d(2):d(2):edge0(2)+d(2)*n;
sampled_points = [kron(sampled_rows, ones(1,n));
                  repmat(sampled_cols, 1, n)]';
              
% Detect cores
for r = 1:4 % for different rotation angle of WDFc
    if ~isempty(sps.core); break; end 
    WDFc1 = 2.0*orientim + r*pi/2; % walking directional field of cores
    core1 = []; core2  = [];
    for i = 1:size(sampled_points,1) % try each starting point
        p = sampled_points(i,:); % starting point
        if ~mask(p(1),p(2)); continue; end
        if isempty(core1) % no upper(lower) core is detected yet
            tempsp = walkonce(im, mask, WDFc1, p, step, Td);
            if checkstable(im, mask, WDFc1, tempsp, step, Td, R)
                core1 = tempsp;
            end
        end
        if isempty(core2) % no lower(upper) core is detected yet
            tempsp = walkonce(im, mask, WDFc1-pi, p, step, Td);
            if checkstable(im, mask, WDFc1-pi, tempsp, step, Td, R)
                core2 = tempsp;
            end
        end
    end
    sps.core = [core1;core2];
end

% Detect deltas
for r = 1:4 % for different rotation angle of WDFd
    if ~isempty(sps.delta); break; end
    WDFd = -2.0*orientim + r*pi/2; % walking directional field of delta
    for i = 1:size(sampled_points,1) % try each starting point
        p = sampled_points(i,:); % starting point
        if ~mask(p(1),p(2)); continue; end
        tempsp = walkonce(im, mask, WDFd, p, step, Td);
        if checkstable(im, mask, WDFd, tempsp, step, Td, R)
            sps.delta = [sps.delta; tempsp];
        end
    end
end

% merge cores(deltas) who are less than 20 pixel.
sps.core = fliplr(mergeneighbors(sps.core, 20));
sps.delta = fliplr(mergeneighbors(sps.delta, 20));
time = toc(ti);
end


% Given a starting point, use walking method to locate a singular point.
% @Usage: 
%   sp = walkonce(im, mask, dfim, start);
%   sp = walkonce(im, mask, dfim, start, step);
%   sp = walkonce(im, mask, dfim, start, step, Td).
% @Inputs:
%   im: 
%       image data, h by w
%   mask:
%       0, background; 1, foreground
%   dfim:
%       pixel wise directional field of \im. Not neccisarily be in [0, pi).
%   start:
%       starting point
%   step:
%       length of one walking step, default to 7 pixel
%   Td:
%       threshold for stopping the walking process, default to 2 pixel
% @Return:
%   sp: 
%       singular point, if failed , sp = [];
%   path: 
%       walking path, a k-by-2 matrix, each row corresponds to a point in 
%       the walking path.
%
% % Coded by Xifeng Guo. All rights reserved. 2015/4/16 % %
%
function [sp, path] = walkonce(im, mask, dfim, start, step, Td)
if nargin < 5; step = 7; end
if nargin < 6; Td = 2; end %default value
sp = [];
current = 1;
path(current,:) = start;
while 1
    temp = path(current,:);
    ori = dfim(temp(1),temp(2));
    current = current + 1;
    path(current,:) = round(temp+step*[-sin(ori),cos(ori)]);
    
    %check the edge
    if any(path(current,:) < 1) || any(path(current,:) - size(im) > 0) ...
            || ~mask(path(current,1), path(current,2))
        break;
    end
    
    %check target
    cpath = path(1:current - 1,:);
    dcpath = cpath - ones(size(cpath,1),1)*path(current,:);
    ind = find(sqrt(dcpath(:,1).^2 + dcpath(:,2).^2) < Td, 1, 'last' );
    if ~isempty(ind) %found a loop, end the walking process
        if current==ind
            sp=path(current,:);
        elseif current - ind <= 9 % the loop is not too large
            sp = round(sum(path(ind:current,:))/(current - ind + 1));
        end
        break;
    end
end 
end


% Check if a candidate singular point is a spurious one.
% @Usage: 
%   stable = checkstable(im, mask, orient, tempsp).
%   stable = checkstable(im, mask, orient, tempsp, step).
%   stable = checkstable(im, mask, orient, tempsp, step, Td).
%   stable = checkstable(im, mask, orient, tempsp, step, Td, R).
% @Inputs:
%   im: 
%       image data, h by w
%   mask:
%       0, background; 1, foreground
%   orientim:
%       pixel wise directional field of \im. Not neccisarily be in [0, pi).
%   tempsp:
%       the candidate singular point to be checked.
%   step:
%       length of one walking step, default to 7 pixel
%   Td:
%       threshold for stopping the walking process, default to 2 pixel
%   R:
%       radius of the neighborhood of the candidate singular point \tempsp,
%       default to 16 pixel
% @Return:
%   stable: 1, \tempsp is genuine; 0, spurious
%
% % Coded by Xifeng Guo. All rights reserved. 2015/4/16 % %
%
function stable = checkstable(im, mask, orientim, tempsp, step, Td, R)
if nargin < 5; step = 7; end
if nargin < 6; Td = 2; end
if nargin < 7; R = 16; end

stable = 0;
if ~isempty(tempsp)  %get a candidate, take a neighbor as a start point to confirm
    stable = 1;
    trystarts = ones(4,1)*tempsp + R*[0,-1; -1,0; 0,1; 1,0];
    for j = 1:4
        if any(trystarts(j,:) < 1) || any(trystarts(j,:) - size(im) > 0)...
                || ~mask(trystarts(j,1), trystarts(j,2))
            stable = 0;
            break;
        end
        newsp = walkonce(im, mask, orientim, trystarts(j,:), step, Td);
        if isempty(newsp) || norm(tempsp - newsp) > R %failed or went away
            stable = 0;
            break;
        end
    end
end
end


% merge points that are too close to each other.
% Usage:
%       mergeneighbors(points, threshold), merge points in \points whose
%       distance between each other is less than \threshold and return the
%       resulting points.
%
% Inputs:
%   points:
%       points to be merged, a n by 2 matrix.
%   threshold:
%       the threshold for mergement.
%
% Outputs:
%   points:
%       merged points, a m by 2 matrix, 1<=m<=n.
%
% % Coded by Xifeng Guo. All rights reserved. 2015/4/27 % %
%
function points = mergeneighbors(points, threshold)
for i = 1:size(points,1)-1
    if points(i,1)==0; continue; end;
    pointi = points(i,:);
    for j = i+1:size(points,1)
        if points(j,1)==0; continue; end;
        if norm(points(i,:)- points(j,:)) < threshold
            pointi = [pointi; points(j,:)];
            points(j,:) = [0 0];
        end
    end
    points(i,:) = round([sum(pointi(:,1)),sum(pointi(:,2))]/size(pointi,1));
end
if ~isempty(points)
    points(points(:,1) == 0,:) = [];
end
end