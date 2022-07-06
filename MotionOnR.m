function [motion]=MotionOnR(R)
%------------------------------------------------
% Motion estimation on the reflectance component.
%
%Inputs:
%   R:reflectance component
%   
%Outputs:
%   motion:estimated motion 
%-------------------------------------------------

v1=R(:,:,1:end-1)*255;
v2=R(:,:,2:end)*255;
window = fspecial('gaussian', 7, 1.5);%11 1.5
window = window/sum(sum(window));
ux=convn(v1,window,'same');
uy=convn(v2,window,'same');
ux_sqr=ux.*ux;
uy_sqr=uy.*uy;
%uxuy=2*ux.*uy+6.5;
uxuy=ux.*uy;
clear ux uy
uxx=convn(v1.*v1,window,'same');
sx=sqrt(abs(uxx-ux_sqr));
clear uxx ux_sqr
uyy=convn(v2.*v2,window,'same');
sy=sqrt(abs(uyy-uy_sqr));
clear uyy uy_sqr
uxy=convn(v1.*v2,window,'same');
sxy=(uxy-uxuy)+0.1*255;
clear uxy uxuy v1 v2
motion=1-sxy./(sx.*sy+0.1*255);
end