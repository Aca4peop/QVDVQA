function frame_num = getFrameNum(filename, height, width)

fid = fopen(filename, 'r');
fseek(fid, 0, 'eof');
size = ftell(fid);
frame_num = size / (height * width * 1.5);
fclose(fid);
