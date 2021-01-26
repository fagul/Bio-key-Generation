function [ WLD_hist, varargout ] = desc_mWLD( img, varargin )
    % DESC_MWLD applies Multi-scale Weber Local Descriptor
    %
    % INPUT:
    %   img - the region that the descriptor would be applied
    %   options -
    %               T - # of quantization levels for oriented gradients
    %               N - # of quantization levels for differential excitation
    %               scaleTop - # of WLD levels
    %               gridHist - [numRow, numCol] 
    %                           or num (scalar) if numRow == numCol
    %               mode - 'nh' for normalized hist
    %
    % OUTPUT:
    %   WLD_hist - feature histogram
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
    
    if isfield(options,'T')
        T = options.T;
    else
        T = 8; %default
    end
    
    if isfield(options,'N')
        N = options.N;
    else
        N = 4; %default
    end
    
    if isfield(options,'scaleTop')
        scaleTop = options.scaleTop;
    else
        scaleTop = 1; %default
    end
    
    scaleCell{1,1} = [1,1;1,2;1,3;2,3;3,3;3,2;3,1;2,1];
    scaleCell{1,2} = [3,2;1,2;2,1;2,3];
    scaleCell{2,1} = [1,1;1,2;1,3;1,4;1,5;2,5;3,5;4,5;5,5;5,4;5,3;5,2;5,1;4,1;3,1;2,1];
    scaleCell{2,2} = [5,3;1,3;3,1;3,5];
    scaleCell{3,1} = [1,1;1,2;1,3;1,4;1,5;1,6;1,7;2,7;3,7;4,7;5,7;6,7;7,7;7,6;7,5;7,4;7,3;7,2;7,1;6,1;5,1;4,1;3,1;2,1];
    scaleCell{3,2} = [7,4;1,4;4,1;4,7];

    BELTA=5; % to avoid that center pixture is equal to zero
    ALPHA=3; % like a lens to magnify or shrink the difference between neighbors
    EPSILON=0.0000001;
    PI=3.141592653589;

    for scale = 1 : scaleTop
        numNeigh = scale*8;

        x_c = img(1+scale:end-scale,1+scale:end-scale);
        [rSize, cSize] = size(x_c);
        link1 = scaleCell{scale,1};
        V00 = zeros(size(x_c));
        for n = 1 : numNeigh
            corner = link1(n,:);
            x_i = img(corner(1):corner(1)+rSize-1,corner(2):corner(2)+cSize-1);
            V00 = V00 + x_i;
        end
        V00 = V00 - numNeigh * x_c;
        imgDE = atan(ALPHA*V00 ./ (x_c+BELTA));
        imgDE = imgDE * 180/PI + 90;

        link2 = scaleCell{scale,2};
        V04 = img(link2(3,1):link2(3,1)+rSize-1,link2(3,2):link2(3,2)+cSize-1)...
            - img(link2(4,1):link2(4,1)+rSize-1,link2(4,2):link2(4,2)+cSize-1);
        V03 = img(link2(1,1):link2(1,1)+rSize-1,link2(1,2):link2(1,2)+cSize-1)...
            - img(link2(2,1):link2(2,1)+rSize-1,link2(2,2):link2(2,2)+cSize-1);

        V03(V03 == 0) = EPSILON;
        imgGO = atan(V04 ./ V03);
        imgGO = imgGO * 180/PI; %scaled to degree from radian
        imgGO(V03 < 0) = imgGO(V03 < 0) + 180;
        imgGO(V03 >= 0 & V04 < 0) = imgGO(V03 >= 0 & V04 < 0) + 360;

%         imgDesc = horzcat(imgGO,imgDE);
        imgDesc(scale).fea.GO = imgGO; options.N = N;
        imgDesc(scale).fea.DE = imgDE; options.T = T;
        
    end
    options.binVec = [];
    options.wldHist = 1;
    
    if nargout == 2
        varargout{1} = imgDesc;
    end
    
    if rowNum == 1 && colNum == 1
        WLD_hist = [];
        for s = 1 : length(imgDesc)
            imgGO = imgDesc(s).fea.GO;
            imgDE = imgDesc(s).fea.DE;

            range = 360 / options.T;
            imgGO = floor(imgGO ./ range);

            range = 180 / options.N;
            imgDE = floor(imgDE ./ range);

            hh = [];
            for t = 0 : options.T - 1
                orien = imgDE(imgGO == t);
                orienHist = hist(orien,0:1:options.N-1);
                hh = horzcat(hh,orienHist);
            end
            WLD_hist = horzcat(WLD_hist,hh);
        end
        if isfield(options,'mode') && strcmp(options.mode,'nh')
            WLD_hist = WLD_hist ./ sum(WLD_hist);
        end
    else
        WLD_hist = ct_gridHist(imgDesc, rowNum, colNum, options);
    end
end