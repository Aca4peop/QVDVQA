function model=TrainModel(features,dmos)

[feat,fmax,fmin]=minmax(features);
index=length(dmos);
[~,bestc,bestg]=SVMcgForRegress(dmos(index),feat(index,:));
svrmodel=svmtrain(dmos,feat,['-c ',num2str(bestc),' -g ',num2str(bestg) ,' -s 3  -p 0.001 -q']);
model.fmax=fmax;
model.fmin=fmin;
model.svrmodel=svrmodel;
end