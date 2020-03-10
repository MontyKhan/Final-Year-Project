% generateMask.m
% Description: Loads DICOM files from an absolute address in the expected
%              format, and generates a histogram based on their content.


close all;                                              % Close open windows and figures to prevent clutter.

imageVector = [];

for n=1:466
%   Read image from file
    filenum = 6623813 + n;                              % 6623814 is the first file in the original set.
    filename = strcat('D:\Final Year Project\Patient Elbow CTs\00000000_DICOM_CT_2018_02_28_000' ...
                       ,num2str(filenum) ...
                       ,'.dcm'); 
    info = dicominfo(filename);
    image = dicomread(info);                            % Will be in Grey units.
    
    imageVector = [imageVector ; double(image(:))];     % Add all data to a vector for analysis of dataset.
end

% Select minimum and maximum values, so they can be used for plotting
% histogram.
minValue = min(min(imageVector));
maxValue = max(max(imageVector));

figure % Open window for histogram
histogram(imageVector,maxValue-minValue);               % Plot histogram with range between minimum and maximum
xlim([-2000 maxValue])                                  % Start at -2000
set(gca, 'YScale', 'log')                               % Set y axis to a logarithmic scale
ylabel('Log of frequency');                             % Label y axis
xlabel('Radiodensity (HU)');                            % Label x axis