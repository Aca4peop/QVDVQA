function I=MP4Read(filename)
%------------------------------------------------
% Read grayscale frames from .mp4 file
%
%-------------------------------------------------
obj = VideoReader(filename);
numFrames = obj.NumberOfFrames;
vidHeight = obj.Height;
vidWidth = obj.Width;
I=uint8(zeros(vidHeight,vidWidth));
for f = 1 : numFrames
    frame = read(obj,f);
    I(:,:,f)=rgb2gray(frame);
end

end