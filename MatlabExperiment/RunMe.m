function RunMe
%2015.2.27
%Mincong:
%Currently there are two error predictions (lags) in LLs and ULs.
%The reason is when the camera has a quick movement, the predictions require
%a few frames to recover to right positions (corners).
%In other words, the time for propagation causes the lags
% Idea: 4 points has correlation rather than individual prediction

clc
clear
close all

%2015.2.26
%Mincong: load from outside to prevent duplicated loading
% Load frames from the whole video into Imgs{}.
% This is really wasteful of memory, but makes subsequent rendering faster.
LoadVideoFrames
load('ll');
load('lr');
load('ul');
load('ur');

numParticles=100;
numDims_w = 2;

llweight_of_samples = ones(numParticles,1);
llweight_of_samples = llweight_of_samples./sum(llweight_of_samples);
llsamples_to_propagate = [1:numParticles]';
llparticles_old = repmat([llminY llminX], numParticles, 1 ) + 5*rand( numParticles, numDims_w );
LLs = zeros(numFrames, numDims_w);

lrweight_of_samples = llweight_of_samples;
lrsamples_to_propagate = llsamples_to_propagate;
lrparticles_old = repmat([lrminY lrminX], numParticles, 1 ) + 5*rand( numParticles, numDims_w );
LRs = LLs;

ulweight_of_samples = llweight_of_samples;
ulsamples_to_propagate = llsamples_to_propagate;
ulparticles_old = repmat([ulminY ulminX], numParticles, 1 ) + 5*rand( numParticles, numDims_w );
ULs = LLs;

urweight_of_samples = llweight_of_samples;
ursamples_to_propagate = llsamples_to_propagate;
urparticles_old = repmat([urminY urminX], numParticles, 1 ) + 5*rand( numParticles, numDims_w );
URs = LLs;

% Coordinates of the known target object (a dark square on a plane) in 3D:
XCart = [-50 -50  50  50;...
    50 -50 -50  50;...
    0   0   0   0];

% These are some approximate intrinsics for this footage.
K = [640  0    320;...
    0    512  256;
    0    0    1];

% Define 3D points of wireframe object.
XWireFrameCart = [-50 -50  50  50 -50 -50  50  50;...
    50 -50 -50  50  50 -50 -50  50;...
    0   0   0   0 -100 -100 -100 -100];


% ================================================
hImg = figure;
for iFrame = 1:numFrames
    [llweight_of_samples,llsamples_to_propagate,llparticles_old,LLs] ...
        = CondensationFilter ...
        ( imgHeight, imgWidth, Imgs,...
        numParticles, llminX, llminY, llpatchOffset, llpixelsTemplate, llpos,...
        llweight_of_samples,llsamples_to_propagate,numDims_w,llparticles_old,iFrame,...
        LLs);
    
    [lrweight_of_samples,lrsamples_to_propagate,lrparticles_old,LRs] ...
        = CondensationFilter ...
        ( imgHeight, imgWidth, Imgs,...
        numParticles, lrminX, lrminY, lrpatchOffset, lrpixelsTemplate, lrpos,...
        lrweight_of_samples,lrsamples_to_propagate,numDims_w,lrparticles_old,iFrame,...
        LRs);
   
    [ulweight_of_samples,ulsamples_to_propagate,ulparticles_old,ULs] ...
        = CondensationFilter ...
        ( imgHeight, imgWidth, Imgs,...
        numParticles,ulminX, ulminY, ulpatchOffset, ulpixelsTemplate, ulpos,...
        ulweight_of_samples,ulsamples_to_propagate,numDims_w,ulparticles_old,iFrame,...
        ULs);
    
    [urweight_of_samples,ursamples_to_propagate,urparticles_old,URs] ...
        = CondensationFilter ...
        ( imgHeight, imgWidth, Imgs,...
        numParticles, urminX, urminY, urpatchOffset, urpixelsTemplate, urpos,...
        urweight_of_samples,ursamples_to_propagate,numDims_w,urparticles_old,iFrame,...
        URs);

    
    xImCart = [LLs(iFrame,:)' ULs(iFrame,:)' URs(iFrame,:)' LRs(iFrame,:)'];
    xImCart = circshift( xImCart, 1);
    
    % To get a frame from footage
    im = Imgs{iFrame};
    
    % Draw image and 2d points
    set(0,'CurrentFigure',hImg);
    set(gcf,'Color',[1 1 1]);
    imshow(im); axis off; axis image; hold on;
    plot(xImCart(1,:),xImCart(2,:),'r.','MarkerSize',15);
    
    
    %calculate TEst the extrinsic matrix relating the
    %plane position to the camera position.
    T = estimatePlanePose(xImCart, XCart, K);
    
   
    %TO DO Draw a wire frame cube, by projecting the vertices of a 3D cube
    %through the projective camera, and drawing lines betweeen the
    %resulting 2d image points
    XImWireFrameCart = projectiveCamera(K,T,XWireFrameCart);
    hold on;
    
    % TO DO: Draw a wire frame cube using data XWireFrameCart. You need to
    % 1) project the vertices of a 3D cube through the projective camera;
    % 2) draw lines betweeen the resulting 2d image points.
    % Note: CONDUCT YOUR CODE FOR DRAWING XWireFrameCart HERE
    %draw lines between each pair of points
    nPoint = size(XWireFrameCart,2);
    for i = 1:nPoint
        for j = 1:nPoint
            %Plot a line between two points that have distance of 100 (is one edge of the cube)
            if  ( sum(abs(XWireFrameCart(:,i) - XWireFrameCart(:,j)))==100 )
                plot([XImWireFrameCart(1,i) XImWireFrameCart(1,j)],[XImWireFrameCart(2,i) XImWireFrameCart(2,j)],'g-');
                hold on;
            end
        end
    end
    hold off;
    drawnow;
    
    %     Optional code to save out figure
    %     pngFileName = sprintf( '%s_%.5d.png', 'myOutput', iFrame );
    %     print( gcf, '-dpng', '-r80', pngFileName ); % Gives 640x480 (small) figure
    
    
end % End of loop over all frames.

%==========================================================================
%==========================================================================
%==========================================================================

%goal of function is to project points in XCart through projective camera
%defined by intrinsic matrix K and extrinsic matrix T.
function xImCart = projectiveCamera(K,T,XCart)

%replace this
xImCart = [];

%TO DO convert Cartesian 3d points XCart to homogeneous coordinates XHom
XHom = [XCart;ones(1,size(XCart,2))];


%TO DO apply extrinsic matrix to XHom to move to frame of reference of
%camera
xCamHom = T*XHom;

%TO DO project points into normalized camera coordinates xCamHom by (achieved by
%removing fourth row)
%Because K is 3x3 matrix
xCamHom(4,:) = [];

%TO DO move points to image coordinates xImHom by applying intrinsic matrix
xImHom = K*xCamHom;

%TO DO convert points back to Cartesian coordinates xImCart
xImCart = xImHom(1:2,:)./repmat(xImHom(3,:),2,1);



%==========================================================================

function T = estimatePlanePose(xImCart,XCart,K)


%Convert Cartesian image points xImCart to homogeneous representation
xImHom = [xImCart;ones(1,size(xImCart,2))];

%Convert image co-ordinates xImHom to normalized camera coordinates
xCamHom = inv(K)*xImHom;

%Estimate homography H mapping homogeneous (x,y)
%coordinates of positions in real world to xCamHom.  Use the routine you wrote for
%Practical 1B.
H = calcBestHomography(XCart, xCamHom);

%Estimate first two columns of rotation matrix R from the first two
%columns of H using the SVD
R = H(:,1:2);
[U,S,V] = svd(R);
R_hat = U*[1,0;0,1;0,0]*V';

%Estimate the third column of the rotation matrix by taking the cross
%product of the first two columns
R_hat = [R_hat cross(R_hat(:,1),R_hat(:,2))];

%Check that the determinant of the rotation matrix is positive - if
%not then multiply last column by -1.
if(det(R_hat)<=0)
    R_hat(end,:) = -1*R_hat(:,end);
end

%Estimate the translation t by finding the appropriate scaling factor k
%and applying it to the third colulmn of H
k = sum(sum(R_hat(:,1:2)./H(:,1:2)));
t = k.*H(:,4); %fourth column
t = t/6; %take the average ratio

%Check whether t_z is negative - if it is then multiply t by -1 and
%the first two columns of R by -1.
t_z = t(end);
if (t_z<0)
    t = -1*t;
    R_hat(:,1:2) = -1*R_hat(:,1:2);
end

%assemble transformation into matrix form
T  = [R_hat t;0 0 0 1];


%==========================================================================
function H = calcBestHomography(pts1Cart, pts2Cart)

%should apply direct linear transform (DLT) algorithm to calculate best
%homography that maps the points in pts1Cart to their corresonding matchin in
%pts2Cart

%first turn points to homogeneous
pts1Hom = [pts1Cart; ones(1,size(pts1Cart,2))];
pts2Hom = [pts2Cart; ones(1,size(pts2Cart,2))];

%then construct A matrix
[m n] = size(pts1Hom);
pts1Hom = pts1Hom';
pts2Hom = pts2Hom';
Y = pts2Hom(:,2);
X = pts2Hom(:,1);
A1 = zeros(n*2,4);
A2 = zeros(n*2,4);
A3 = zeros(n*2,4);
for i = 1:n
    A1(2*i-1,:) = pts1Hom(i,:);
    A2(2*i,:) = pts1Hom(i,:);
    A3(2*i-1,:) = -X(i)*pts1Hom(i,:);
    A3(2*i,:) = -Y(i)*pts1Hom(i,:);
end
A = [A1 A2 A3];

%solve Ah = 0 by calling
%h = solveAXEqualsZero(A); (you have to write this routine too - see below)
h = solveAXEqualsZero(A);

%reshape h into the matrix H
H = reshape(h,4,3)';


%==========================================================================
function x = solveAXEqualsZero(A);
[U,S,V] = svd(A);
x = V(:,end);