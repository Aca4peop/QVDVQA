function feat=VideoFeatExtrat(frames,device)
%------------------------------------------------
% Feature extraction on video
%
%Inputs:
%   frames:video frames with grayscale
%   device: 'gpu' or 'cpu'
%Outputs:
%   feat:QVDVQA features 
%-------------------------------------------------
%%
if device=='gpu'
    if ~canUseGPU()
        errID = 'VideoFeatExtrat:device';
        msg = 'GPU device unavailable';
       throw(MException(errID,msg));
    end
elseif device~='cpu'
      errID = 'QVDVQA:VideoFeatExtrat:device';
        msg = 'Unrecognized device parameter.Only supprt cpu or gpu';
       throw(MException(errID,msg));  
end
%%
feat=[];
saclenum=3;
for s=1:saclenum
    
if device=='gpu'
framesgpu=gpuArray(single(frames));
else
framesgpu=single(frames);
end

[R,I]=Retinex(framesgpu);

%% Frame Distortion
[AGGDS,Ids]=FrameFeatExtrat(R,I,device);
% memory 
aggd_s=mean(AGGDS);
id_s=mean(Ids);
% temporal var
aggd_t=std(diff(AGGDS));
id_t=std(diff(Ids));

%% Motion Distortion
mot_t=zeros(1,4);% temporal var
mot_s=zeros(1,4);% motion smootheness
if device=='gpu'
    mot_t=gpuArray(mot_t);
    mot_s=gpuArray(mot_s);
end
motion_R=MotionOnR(R);
mean_motion_R=mean(mean(motion_R));
max_motion_R=max(max(motion_R));
% temporal var
mot_t(1)=std(diff(mean_motion_R));
mot_t(2)=std(diff(max_motion_R));
% motion smootheness
motion_dx_R=abs(motion_R(1:end-1,:,:)-motion_R(2:end,:,:));
motion_dy_R=abs(motion_R(:,1:end-1,:)-motion_R(:,2:end,:));
mot_s(1)=max(mean(mean(motion_dx_R)));
mot_s(2)=max(mean(mean(motion_dy_R)));
clear motion_R motion_dx_R motion_dy_R motion_dd1_R motion_dd2_R

motion_I=MotionOnI(I);
mean_motion_I=mean(mean(motion_I));
max_motion_I=max(max(motion_I));
% temporal var
mot_t(3)=std(diff(mean_motion_I));
mot_t(4)=std(diff(max_motion_I));
% motion smootheness
motion_dx_I=abs(motion_I(1:end-1,:,:)-motion_I(2:end,:,:));
motion_dy_I=abs(motion_I(:,1:end-1,:)-motion_I(:,2:end,:));
mot_s(3)=max(mean(mean(motion_dx_I)));
mot_s(4)=max(mean(mean(motion_dy_I)));
if device=='gpu'
    mot_t=gather(mot_t);
    mot_s=gather(mot_s);
end
clear motion_I motion_dx_I motion_dy_I motion_dd1_I motion_dd2_I
feat=[feat aggd_s id_s aggd_t id_t mot_t mot_s];
%% down-sampling
if s<saclenum
frames=imresize(frames,0.5,'nearest');
end

end
end
