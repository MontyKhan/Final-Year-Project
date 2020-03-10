% icp_time.m
% Description: Used to compare accuracy of different downsampling levels

% Set original rotation matrix
rotate = [cos(pi/4) -sin(pi/4) 0 0;
          sin(pi/4)  cos(pi/4) 0 0;
          0          0         1 0;
          0          0         0 1];
      
transform = affine3d(rotate);                                           % Create affine transformation from rotation matrix

tElbow = pctransform(lElbow, transform);                                % Transform point cloud

step = 10                                                               % Set downsampling level to 10, publish to terminal

tic

ds_l = pcdownsample(lElbow, 'gridAverage', step);                       % Downsample original limb by step
ds_t = pcdownsample(tElbow, 'gridAverage', step);                       % Downsample rotated limb by step
[tform,movingreg,rmse] = pcregistericp(ds_l,ds_t,'Extrapolate',true);   % Extrapolate rotation matrix

toc                                                                     % Publish time taken to terminal

step = 5

tic

ds_l = pcdownsample(lElbow, 'gridAverage', step);
ds_t = pcdownsample(tElbow, 'gridAverage', step);
[tform,movingreg,rmse] = pcregistericp(ds_l,ds_t,'Extrapolate',true);

toc

step = 2

tic

ds_l = pcdownsample(lElbow, 'gridAverage', step);
ds_t = pcdownsample(tElbow, 'gridAverage', step);
[tform,movingreg,rmse] = pcregistericp(ds_l,ds_t,'Extrapolate',true);

toc

step = 1

tic

ds_l = pcdownsample(lElbow, 'gridAverage', step);
ds_t = pcdownsample(tElbow, 'gridAverage', step);
[tform,movingreg,rmse] = pcregistericp(ds_l,ds_t,'Extrapolate',true);

toc

step = 0.5

tic

ds_l = pcdownsample(lElbow, 'gridAverage', step);
ds_t = pcdownsample(tElbow, 'gridAverage', step);
[tform,movingreg,rmse] = pcregistericp(ds_l,ds_t,'Extrapolate',true);

toc

step = 0

tic

ds_l = lElbow;
ds_t = tElbow;
[tform,movingreg,rmse] = pcregistericp(ds_l,ds_t,'Extrapolate',true);

toc