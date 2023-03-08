clear
addpath('..')
load LIVEVIDEOData.mat;
root = 'D:\DataBase\Video\LIVE_VQA\videos\';
feat=zeros(160,48);


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

