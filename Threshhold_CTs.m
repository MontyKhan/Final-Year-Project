% Threshold_CTs.m
% Description: Loads DICOM files from an absolute address in the expected
%              format, and generates a set of binary masks and a 3D point 
%              cloud representing each mask as a layer.

close all;                                                      % Close open windows and figures to prevent clutter.

% Initialize vectors
imageVector = [];
mask_3d = [];

% Set paths
input = 'D:\Coursework\Final Year Project\Patient Elbow CTs\';
output = 'D:\Coursework\Final Year Project\threshholds4\';

% Calculate number of files in input folder 
d = dir('D:\Coursework\Final Year Project\Patient Elbow CTs\*.dcm');
file_count = length(d);

% Set original patient ID
info = dicominfo(strcat(input, getfield(d,{1},'name')));
patientID = info.PatientID;
protocol = info.ProtocolName;

% Left joint
% for n = 1:92
% Right joint

for n = 1:file_count
    fprintf('Processing %i of %i\n', n, file_count);
    
    %% Generate masks
    filename = strcat(input ...                                 % Load file (directory)
                      ,getfield(d,{n},'name'));                              % Load file (name)
    info = dicominfo(filename);
    
    if (contains((getfield(info,{1},'ImageType')), 'Secondary'))
        continue;
    end
    
    newID = info.PatientID;
    newProtocol = info.ProtocolName;
    
    if (~strcmp(newID, patientID) || ~strcmp(newProtocol, protocol))
        % Create point cloud
        ptCloud = pointCloud(mask_3d);

        % Show point cloud
        pcshow(ptCloud)

        % Save point cloud
        fprintf('Generating point cloud.\n');
        pt_name = strcat('D:\Coursework\Final Year Project\point_clouds\',patientID,'_',protocol(1),'_pc');
        pcwrite(ptCloud,pt_name,'PLYFormat','binary');
        
        % Clear mask_3d for next patient
        mask_3d = [];
        
        % Update patient ID
        patientID = newID;
        protocol = newProtocol;
        info = info;
    end

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
    cd 'D:\Coursework\Final Year Project\threshholds4';
    filename = strcat(patientID,'_',protocol(1),'_th_',num2str(n),'.png');
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