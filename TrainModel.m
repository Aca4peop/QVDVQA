function vqamodel=TrainModel(features,dmos)
%------------------------------------------------
% Train QVDVQA model
%-------------------------------------------------
[feat,fmax,fmin]=minmax(features);
index=1:length(dmos);
[~,bestc,bestg]=SVMcgForRegress(dmos(index),feat(index,:));
svrmodel=svmtrain(dmos,feat,['-c ',num2str(bestc),' -g ',num2str(bestg) ,' -s 3  -p 0.001 -q']);
vqamodel.fmax=fmax;
vqamodel.fmin=fmin;
vqamodel.svrmodel=svrmodel;
end