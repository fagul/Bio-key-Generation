function [ MBP_hist, varargout ] = desc_MBP( img, varargin )
    % DESC_MBP applies Median Binary Pattern
    %
    % INPUT:
    %   img - the region that the descriptor would be applied
    %   options -
    %               gridHist - [numRow, numCol] 
    %                           or num (scalar) if numRow == numCol
    %               mode - 'nh' for normalized hist
    %
    % OUTPUT:
    %   MBP_hist - feature histogram
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
    
    if nargin == 2
        options = varargin{1};
    else
        options = struct;
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
    
    rSize = size(img,1)-2;
    cSize = size(img,2)-2;
    link = [2,1;1,1;1,2;1,3;2,3;3,3;3,2;3,1];
    ImgIntensity = zeros(rSize*cSize,1);

    for n = 1 : size(link,1)
        corner = link(n,:);
        ImgIntensity(:,n) = reshape(img(corner(1):corner(1)+rSize-1,corner(2):corner(2)+cSize-1),[],1);
    end

    medianMat = median(ImgIntensity,2);

    MBP = double(ImgIntensity > repmat(medianMat,1,8));
    imgDesc = reshape(bi2de(MBP),rSize,cSize);
    options.binVec = 0:255;
    
    if nargout == 2
        varargout{1} = imgDesc;
    end
    
    if rowNum == 1 && colNum == 1
        MBP_hist = hist(imgDesc(:),options.binVec);
        if isfield(options,'mode') && strcmp(options.mode,'nh')
            MBP_hist = MBP_hist ./ sum(MBP_hist);
        end
    else
        MBP_hist = ct_gridHist(imgDesc, rowNum, colNum, options);
    end
end