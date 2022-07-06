function qp=(frames,model)
features=VideoFeatExtrat(frames,'gpu');
features=minmax(features,model.fmax,model.fmin);
[qp,~,~]=svmpredict(zeros(1,1),features,model.svrmodel);
end