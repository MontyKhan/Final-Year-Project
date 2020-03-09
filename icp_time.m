rotate = [cos(pi/4) -sin(pi/4) 0 0;
          sin(pi/4)  cos(pi/4) 0 0;
          0          0         1 0;
          0          0         0 1];
      
transform = affine3d(rotate);

tElbow = pctransform(lElbow, transform);

step = 10

tic

ds_l = pcdownsample(lElbow, 'gridAverage', step);
ds_t = pcdownsample(tElbow, 'gridAverage', step);
[tform,movingreg,rmse] = pcregistericp(ds_l,ds_t,'Extrapolate',true);

toc

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