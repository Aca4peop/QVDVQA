clear
addpath('..')
 load('LIVEVIDEOData.mat')
 load('LIVE_feats.mat')
 warning off
%%
[feat,~,~]=minmax(feat);
[dmos_all,~,~]=minmax(dmos_all);
%%
SROCC=zeros(1000,5);
PLCC=zeros(1000,5);
RMSE=zeros(1000,5);
index=randperm(160);
 [~,bestc,bestg]=SVMcgForRegress(dmos_all(index),feat(index,:));


t=1
 while t<=1000

%%
index=randperm(160);
spilt_key=round(160*0.8);
train_index=index(1:spilt_key);
test_index=index(spilt_key:end);
x_train1=feat(train_index,:);
y_train=dmos_all(train_index);

%%
x_test1=feat(test_index,:);

dis_test=dis_type(test_index);
dmos=dmos_all(test_index);
M1=svmtrain(y_train,x_train1,['-c ',num2str(bestc),' -g ',num2str(bestg) ,' -s 3  -p 0.001 -q']);
[testscores,~,~]=svmpredict(dmos,x_test1,M1);

 dis_typee=dis_type(test_index);
tmp=zeros(1,5);
if length(testscores(dis_typee==1))>0 &&length(testscores(dis_typee==2))>0 &&length(testscores(dis_typee==3))>0 &&length(testscores(dis_typee==4))>0 
tmp(1)=abs(corr(testscores(dis_typee==1), dmos(dis_typee==1),'type','Spearman'));
if isnan(tmp(1))
    continue
end
tmp(2)=abs(corr(testscores(dis_typee==2), dmos(dis_typee==2),'type','Spearman'));
if isnan(tmp(2))
    continue
end
tmp(3)=abs(corr(testscores(dis_typee==3), dmos(dis_typee==3),'type','Spearman'));
if isnan(tmp(3))
    continue
end
tmp(4)=abs(corr(testscores(dis_typee==4), dmos(dis_typee==4),'type','Spearman'));
if isnan(tmp(4)) 
    continue
end
tmp(5)=abs(corr(testscores, dmos,'type','Spearman'));

SROCC(t,:)=tmp;
tmpp=zeros(1,5);



beta(1) = 1;
beta(2) = 0;
beta(3) = mean(testscores);
beta(4) = 0.1;
beta(5) = 0.1;

%fitting a curve using the data
[bayta,ehat,J] = nlinfit(testscores,dmos,@logistic,beta);
%given a ssim value, predict the correspoing mos (ypre) using the fitted curve
[log_fitted_obj,~] = nlpredci(@logistic,testscores,bayta,ehat,J);
tmp(1)=abs(corr(log_fitted_obj(dis_typee==1), dmos(dis_typee==1),'type','Pearson'));
tmp(2)=abs(corr(log_fitted_obj(dis_typee==2), dmos(dis_typee==2),'type','Pearson'));
tmp(3)=abs(corr(log_fitted_obj(dis_typee==3), dmos(dis_typee==3),'type','Pearson'));
tmp(4)=abs(corr(log_fitted_obj(dis_typee==4), dmos(dis_typee==4),'type','Pearson'));
tmp(5)=abs(corr(log_fitted_obj, dmos,'type','Pearson'));
tmpp(1)=rmse(log_fitted_obj(dis_typee==1), dmos(dis_typee==1));
tmpp(2)=rmse(log_fitted_obj(dis_typee==2), dmos(dis_typee==2));
tmpp(3)=rmse(log_fitted_obj(dis_typee==3), dmos(dis_typee==3));
tmpp(4)=rmse(log_fitted_obj(dis_typee==4), dmos(dis_typee==4));
tmpp(5)=rmse(log_fitted_obj, dmos);
PLCC(t,:)=tmp;
RMSE(t,:)=tmpp;

 median(SROCC(1:t,:))

t=t+1;
 end
 end
clc
srocc_median=median(SROCC)
 plcc_median=median(PLCC)
 r_mse_median=median(RMSE)

function yhat = logistic(bayta,X)

bayta1 = bayta(1); 
bayta2 = bayta(2); 
bayta3 = bayta(3); 
bayta4 = bayta(4);
bayta5 = bayta(5);

logisticPart = 0.5 - 1./(1 + exp(bayta2 * (X - bayta3)));

yhat = bayta1 * logisticPart + bayta4*X + bayta5;
end
function re=rmse(X,Y)
re=sqrt(mean((X-Y).^2));
end