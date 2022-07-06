function [AGGDS,Id]=FrameFeatExtrat(R,I,device)
%% R
R(R==0)=0.001;
windows = fspecial('gaussian',7,1.8);
windows=windows./(sum(windows(:)));
nrf=convn(R,windows,'same')+0.001;
nrf=nrf(4:end-3,4:end-3,:);
R_=(R(4:end-3,4:end-3,:)+0.001)./nrf;

if device=='gpu'
   R_=gather(R_); 
end
clear nrf R
% frame level AGGD
[~,~,lens]=size(R_);
AGGDS=zeros(lens,3);
delbox=[];
for f=1:lens
    im=R_(:,:,f);
    [ alpha,leftstd,rightstd] = estimateaggdparam(im(:));
    AGGDS(f,1:3)=[ alpha  leftstd^2 rightstd^2];
   if(isnan(alpha)||isnan(leftstd)||isnan(rightstd))
       delbox=[delbox,f];
   end
end
AGGDS(delbox,:)=[];
clear R_
%% I
% relative brightness
w=[0,1,0;1,0,1;0,1,0];
nrf=convn(I,w,'valid')/4;
I_ = I(2:end-1,2:end-1,:)-nrf; 
% frame level skewness
Id=max(max(I_));
if device=='gpu'
   Id=gather(Id); 
end
Id=reshape(Id,[],1);
end