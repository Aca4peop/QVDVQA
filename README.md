**Motion Measurement and Quality Variation Driven Video Quality Assessment**

[![license](https://img.shields.io/github/license/Aca4peop/QVDVQA)](https://github.com/Aca4peop/QVDVQA/blob/main/LICENSE)
# Description
Matlab code for *Motion Measurement and Quality Variation Driven Video Quality Assessment*

# Requirements

**LibSVM：** [LIBSVM -- A Library for Support Vector Machines (ntu.edu.tw)](https://www.csie.ntu.edu.tw/~cjlin/libsvm/) 

# Usages

## 1. Quality prediction

```
load QVDVQA_model.mat
frames=single(Yuv2Frame(video_path, video_height, video_width));% for .yuv video

% frames=single(MP4Read(video_path));% for .mp4 video

quality_predict=QVDVQA(frames,vqamodel)
```

## 2. Train a new model

### 1. Feature extraction

```matlab
frames=single(Yuv2Frame(video_path, video_height, video_width));% for .yuv video

% frames=single(MP4Read(video_path));% for .mp4 video

features=VideoFeatExtrat(frames,'gpu');  % cpu or gpu are supported


```
The provided model was trained on the entire LIVE database.

### 2. Model training

```
load train_features.mat
load train_dmos.mat
svrmodel=TrainModel(train_features,train_dmos)
save('your_model.mat','svrmodel')
```

The train_features are feature matrix (video num × feature dimension) extracted from training sets.

The train_dmos are dmos (video num × 1) of training sets.



# Demo

We provide a [demo](https://github.com/Aca4peop/QVDVQA/tree/main/demo) for training and evaluating model on the LIVE database.
# Contact
