close all;

imageVector = [];

for n=1:466
%   Read image from file
    filenum = 6623813 + n;
%     filenum = 6623828;
    filename = strcat('D:\Final Year Project\Patient Elbow CTs\00000000_DICOM_CT_2018_02_28_000',num2str(filenum),'.dcm'); 
    info = dicominfo(filename);
    image = dicomread(info);            % Will be in Grey units.
    
% %     Display raw image
%     figure
%     imshow(image,[]);
    
    imageVector = [imageVector ; double(image(:))];
end

% % Remove values for regions off CT scan
% for n=1:size(imageVector,1)
%     if (imageVector(n) == -2048)
%         imageVector(n) = [];
%     end
% end

minValue = min(min(imageVector));
maxValue = max(max(imageVector));

% figure
% imhist(image,4729);
figure
histogram(imageVector,maxValue-minValue);
% bar(intensity_hist);
xlim([-2000 maxValue])
set(gca, 'YScale', 'log')
ylabel('Log of frequency');
xlabel('Radiodensity (HU)');
% ylim([0 477700])

% figure
% % imshow(normImage > 0.51);
% imshow(normImage > 0.505);

% % Try and create a histogram
% image_vector = reshape(image,1,size(image,1)*size(image,2));
% intensity_hist = hist(image_vector,31000);
% 
% figure
% bar(intensity_hist);
% 
% bone = image(image > 1800);
% bone = bone(bone < 1900);
% 
% figure
% imshow(bone,[]);