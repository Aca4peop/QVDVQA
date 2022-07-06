
function qp=QVDVQA(frames,model)
%------------------------------------------------
% QVDVQA£ºmain code for Motion Measurement and Quality Variation Driven Video Quality Assessment
%
%Inputs:
%   frames:video frames with grayscale
%   model: Pretrained model struct
%Outputs:
%   qp:quality prediction
%-------------------------------------------------

features=VideoFeatExtrat(frames,'cpu');
features=double(minmax(features,model.fmax,model.fmin));
[qp,~,~]=svmpredict(ones(1,1),features,model.svrmodel);

end