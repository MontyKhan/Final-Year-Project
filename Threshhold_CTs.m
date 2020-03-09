close all;

imageVector = [];

mask_3d = [];

% for n=1:466
% for n=1:47
% Left joint
% for n = 1:92
% Right joint
for n = 1:90
%   Read image from file
    filenum = 6624043 + n;
%     filenum = 6623828;
% Left joint
    % filename = strcat('D:\Final Year Project\Patient Elbow CTs\00000000_DICOM_CT_2018_02_28_000',num2str(filenum),'.dcm'); 
% Right joint
    filename = strcat('D:\Final Year Project\Patient Elbow CTs\00000000_DICOM_CT_2018_02_28_000',num2str(filenum),'.dcm'); 
    info = dicominfo(filename);
    image = dicomread(info);            % Will be in Grey units.
    
%     Display raw image
%     figure
%     imshow(image,[]);
    
    mask = (image > 300);
    seOpen = strel('disk',2);
    seClose = strel('disk',2);
    cleanMask = imopen(mask, seOpen);
    cleanMask = imclose(cleanMask,seClose);
    
    imageDisplay = mat2gray(image);
    
%     figure
%     imshow(mask, []);

      %outdisplay = imshowpair(image,mask,'montage');
      %imshowpair(mask,cleanMask,'montage');
%       outdisplay = montage({imageDisplay mask cleanMask}, 'Size', [1 3], 'DisplayRange',[]);
%       cd 'D:\Final Year Project\threshholds2';
%       filename = strcat('th_',num2str(n),'.png');
%       saveas(outdisplay,filename);

%       figure;
%       imshow(cleanMask);
%       
      
    % Convert to list of coordinates
    for i = 1:size(cleanMask,2)
        for j = 1:size(cleanMask,1)
            if (cleanMask(i,j) == 1)
                mask_3d = [mask_3d ; [i j (n*1.3)]];
            end
        end
    end

%     mask_3d = cat(3, mask_3d, cleanMask);
end

% scatter3(mask_3d(:,2), mask_3d(:,1), mask_3d(:,3));
% blockPlot(mask_3d);

% Create point cloud
ptCloud = pointCloud(mask_3d);

pcshow(ptCloud)