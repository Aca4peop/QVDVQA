clear
addpath('..')
load LIVEVIDEOData.mat;
% root = 'D:\DataBase\Video\LIVE_VQA\videos\';
% root='D:\LIVE_VQA\videos\'
root = '/home1/server823-2/database/2D-Video/live/videos/';
feat=zeros(160,96);


for i=1:160
name=file_name{i};
filename=[root  name]
frames=double(Yuv2Frame(filename, 432, 768));
tic
try
feat(i,:)=VideoFeatExtrat(frames,'gpu');
catch
feat(i,:)=VideoFeatExtrat(frames,'cpu');
end
toc
end
info='';
save('LIVE_feats','feat')

