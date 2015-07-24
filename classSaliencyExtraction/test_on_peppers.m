% number of desired image
imno = 1;

net_vgg = 'imagenet-vgg-f.mat';
net_alex = 'imagenet-caffe-alex.mat';

% i choose alex
net = load(net_alex);

load('imdb.mat');

im = imread(imdb(imno).name);

% pre-process image
im_ = single(im);
im_ = imresize(im_, net.normalization.imageSize(1:2));
im_ = im_ - net.normalization.averageImage;

saliency_map = saliency_extraction(net, im_, imdb(imno).class, 15); % a map for each channel
saliency_absol = abs(saliency_map);
saliency_absol = max(saliency_absol,[],3);
% take the norm of the 3D saliency map for each pixel
saliency_norm = sqrt(sum(saliency_map .^ 2,3));

figure(1); clf;
subplot(2,2,1); imagesc(im); title('original');
subplot(2,2,2); imagesc(saliency_norm); title('saliency norm'); colormap gray; colorbar;
subplot(2,2,3); imagesc(saliency_absol); title('saliency absol'); colormap gray; colorbar;