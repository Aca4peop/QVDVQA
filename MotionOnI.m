function [motion]=MotionOnI(I)
%------------------------------------------------
% Motion estimation on the illumination component.
%
%Inputs:
%   I:illumination component
%   
%Outputs:
%   motion:estimated motion 
%-------------------------------------------------
v1=I(:,:,1:end-1);
v2=I(:,:,2:end);
window = fspecial('gaussian', 11, 1.5);
window = window/sum(sum(window));
ux=convn(v1,window,'same');
uy=convn(v2,window,'same');
motion=abs(ux-uy);
end