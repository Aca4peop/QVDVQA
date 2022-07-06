function frame = Yuv2Frame(filename, height,width, frameNum)

if (nargin == 3)
	frameNum = getFrameNum(filename, height, width);
end

fid = fopen(filename, 'r');
fseek(fid, 0, 'bof');
Y = zeros(height, width, frameNum);

for index_frame = 1:frameNum
    temp = fread(fid, width * height,'uchar')';
    temp = reshape(temp, [width height]);
    Y(:, :, index_frame) = temp';
    Cb = fread(fid, width * height / 4, 'uchar');
    Cr = fread(fid, width * height / 4, 'uchar');
end

frame = Y;
fclose(fid);