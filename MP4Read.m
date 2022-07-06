function I=MP4Read(filename)
obj = VideoReader(filename);
numFrames = obj.NumberOfFrames;
vidHeight = obj.Height;
vidWidth = obj.Width;
I=uint8(zeros(vidHeight,vidWidth));
for f = 1 : numFrames% ¶ÁÈ¡Êý¾Ý
    frame = read(obj,f);
    I(:,:,f)=rgb2gray(frame);
end

end