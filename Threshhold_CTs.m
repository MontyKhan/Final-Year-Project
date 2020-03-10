% Threshold_CTs.m
% Description: Loads DICOM files from an absolute address in the expected
%              format, and generates a set of binary masks and a 3D point 
%              cloud representing each mask as a layer.

close all;                                                      % Close open windows and figures to prevent clutter.

% Initialize vectors
imageVector = [];
mask_3d = [];

% Set paths
input = 'D:\Final Year Project\Patient Elbow CTs\00000000_DICOM_CT_2018_02_28_000';
output = 'D:\Final Year Project\threshholds3';

% Left joint
% for n = 1:92
% Right joint

for n = 1:90
    %% Generate masks
    filenum = 6624043 + n;                                      % Read image from file (right joint)
%   filenum = 6623828;                                          % Read image from file (left joint)

    filename = strcat(input ...                                 % Load file
                      ,num2str(filenum) ...
                      ,'.dcm');
    info = dicominfo(filename);
    image = dicomread(info);                                    % Will be in Grey units.
    
    mask = (image > 300);                                       % Threshold out values below 300 (i.e. soft tissue)
    seOpen = strel('disk',2);                                   % Set dilate
    seClose = strel('disk',2);                                  % Set erode
    cleanMask = imopen(mask, seOpen);                           % Dilate
    cleanMask = imclose(cleanMask,seClose);                     % Erode
    
    %% IF LOOKING TO COMPARE IMAGES
    % imageDisplay = mat2gray(image);                           % Convert original image to grayscale
    % outdisplay = montage({imageDisplay mask cleanMask}  ...   % Create new image of original image, mask and cleaned mask in a row
    %                      , 'Size', [1 3] ...              
    %                      ,'DisplayRange',[]);
    % cd 'D:\Final Year Project\threshholds2';                  % Change working directory             
    % filename = strcat('th_',num2str(n),'.png');               % Save
    % saveas(outdisplay,filename);

    %% IF LOOKING TO SAVE MASKS
    cd 'D:\Final Year Project\threshholds3';
    filename = strcat('th_',num2str(n),'.png');
    imwrite(cleanMask,filename);
      
    %% Convert to list of coordinates
    for i = 1:size(cleanMask,2)
        for j = 1:size(cleanMask,1)
            if (cleanMask(i,j) == 1)
                mask_3d = [mask_3d ; [i j (n*1.3)]];
            end
        end
    end
end

% Create point cloud
ptCloud = pointCloud(mask_3d);

% Show point cloud
pcshow(ptCloud)