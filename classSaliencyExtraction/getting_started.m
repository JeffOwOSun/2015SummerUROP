% setup MatConvNet in MATLAB
% run matlab/vl_setupnn
% load a pre-trained CNN
net = load('imagenet-caffe-alex.mat');
% obtain and preprocess an image
im = imread('370Z.jpg'); % read image
im_ = single(im); % note: 255 range
im_ = imresize(im_, net.normalization.imageSize(1:2)); % resize to image of size 224 by 224
im_ = im_ - net.normalization.averageImage; % minus averageImage
% run the CNN
res = vl_simplenn(net, im_);
% show the classification result
scores = squeeze(gather(res(end).x));
[bestScore, best] = max(scores);
figure(1); clf; imagesc(im);
title(sprintf('%s (%d), score %.3f',...
    net.classes.description{best}, best, bestScore));
