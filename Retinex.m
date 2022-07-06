function [R,I]=Retinex(frames)
ksize=7;
kstd=1;
% frames=gpuArray(frames);
frames(frames==0)=0.001;

%% Parameter checking
gk=fspecial('gaussian', ksize,kstd); 
I = convn(frames, gk,'same');
I(I==0)=0.001;
R=log(frames)-log(I);
R=exp(R);
R = (R - min(min(R)))./(max(max(R)) - min(min(R)));
I = (I - min(min(I)))./(max(max(I)) - min(min(I)));
end