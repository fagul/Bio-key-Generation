function [ LTrP_hist, varargout ] = desc_LTrP( img, varargin )
    % DESC_LTrP applies Local Transitional Pattern
    %
    % INPUT:
    %   img - the region that the descriptor would be applied
    %   options -
    %               gridHist - [numRow, numCol] 
    %                           or num (scalar) if numRow == numCol
    %               mode - 'nh' for normalized hist
    %
    % OUTPUT:
    %   LTrP_hist - feature histogram
    %   imgDesc - descriptor image
    % 
    % ABOUT
    % Created:      9.4.2017
    % Last Update:  5.8.2018
    % Version:      1.0
    %
    % WHEN PUBLISHING A PAPER AS A RESULT OF RESEARCH CONDUCTED BY USING THIS CODE
    % OR ANY PART OF IT, MAKE A REFERENCE TO THE FOLLOWING PUBLICATIONS:
    %
    %   Cigdem Turan and Kin-Man Lam, �Histogram-based Local Descriptors for Facial 
    %   Expression Recognition (FER): A comprehensive Study,� Journal of Visual 
    %   Communication and Image Representation, 2018. doi: 10.1016/j.jvcir.2018.05.024
    %
    %
    % Copyright (c) 2018 Cigdem Turan
    % Department of Electronic and Information Engineering,
    % The Hong Kong Polytechnic University
    % 
    % Permission is hereby granted, free of charge, to any person obtaining a copy
    % of this software and associated documentation files, to deal
    % in the Software without restriction, subject to the following conditions:
    % 
    % The above copyright notice and this permission notice shall be included in 
    % all copies or substantial portions of the Software.
    %
    % The Software is provided "as is", without warranty of any kind.
    % 
    % August 2018
    
    img = double(img);
    
    if nargin == 3
        flag = varargin{2};
        options = varargin{1};
    elseif nargin == 2
        options = varargin{1};
        flag = 1;
    else
        options = struct;
        flag = 1;
    end
    
    if isfield(options,'gridHist') && length(options.gridHist) == 2
        rowNum = options.gridHist(1);
        colNum = options.gridHist(2);
    elseif isfield(options,'gridHist') && length(options.gridHist) == 1
        rowNum = options.gridHist;
        colNum = options.gridHist;
    else
        rowNum = 1;
        colNum = 1;
    end
    
    linkList = {[4,4;5,5],[4,3;5,3],[4,2;5,1],[3,2;3,1],[2,2;1,1],[2,3;1,3],[2,4;1,5],[3,4;3,5]};
    x_c = img(3:end-2,3:end-2);
    [rSize, cSize] = size(x_c);
    imgDesc = zeros(size(x_c));
    for n = 1 : size(linkList,2)
        corner1 = linkList{n}(1,:);
        corner2 = linkList{n}(2,:);
        x_p1 = img(corner1(1):corner1(1)+rSize-1,corner1(2):corner1(2)+cSize-1);
        x_p2 = img(corner2(1):corner2(1)+rSize-1,corner2(2):corner2(2)+cSize-1);
%         imgDesc = imgDesc + double(~xor((x_p1 - x_c) >= 0,(x_p2 - x_c))) .* 2^(size(linkList,2)-n);
        imgDesc = imgDesc + double(xor((x_p1 - x_c) >= 0,(x_p2 - x_c) >= 0)) .* 2^(size(linkList,2)-n);
    %     pattern = pattern + double(((x_p1 - x_p2) > 0)) .* 2^(size(linkList,2)-n);
    end
    
    if nargout == 2
        varargout{1} = imgDesc;
    end
    
    if flag == 1
        options.binVec = 0:255;
        
        if rowNum == 1 && colNum == 1
            LTrP_hist = hist(imgDesc(:),options.binVec);
            if isfield(options,'mode') && strcmp(options.mode,'nh')
                LTrP_hist = LTrP_hist ./ sum(LTrP_hist);
            end
        else
            LTrP_hist = ct_gridHist(imgDesc, rowNum, colNum, options);
        end
    else
        LTrP_hist = [];
    end
end