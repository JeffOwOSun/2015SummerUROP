function [net, res] = gender_classification(im)

setup;

net = load('gender-classification-vgg-f.mat');

% obtain and preprocess an image
im = imread(im);
im_ = single(im);
im_ = imresize(im_, net.normalization.imageSize(1:2));
im_ = im_ - net.normalization.averageImage;

% run the CNN
res = vl_simplenn(net, im_);

% show the classiication result
scores = squeeze(gather(res(end).x));
[bestScore, best] = max(scores);
description = {'female', 'male'};
figure(1); clf; imagesc(im);
title(sprintf('%s (%d), score %.3f', ...
    description{best}, best, bestScore));