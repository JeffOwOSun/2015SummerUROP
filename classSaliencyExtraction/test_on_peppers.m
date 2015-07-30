run setup.m;

% load network
net_vgg = 'imagenet-vgg-f.mat';
net_alex = 'imagenet-caffe-alex.mat';
% I choose alex
net = load(net_alex);

% load Image
% number of desired image
imno = 1;
load('imdb.mat');
im = imread(imdb(imno).name);
% pre-process image
im_ = single(im);
im_ = imresize(im_, net.normalization.imageSize(1:2));
im_ = im_ - net.normalization.averageImage;

% extract saliency
layerno = 16; % look at the INPUT of 16-th layer
[saliency_map, feature_map] = saliency_extraction(net, im_, imdb(imno).class, layerno); % a map for each channel

% plot the average of the activation
saliency_absol = abs(saliency_map);
saliency_absol = max(saliency_absol,[],3);
% take the norm of the 3D saliency map for each pixel
saliency_norm = sqrt(sum(saliency_map .^ 2,3));

figure(1); clf;
subplot(2,2,1); imagesc(im); title('original');
subplot(2,2,2); imagesc(saliency_norm); title('saliency norm'); colormap gray; colorbar;
subplot(2,2,3); imagesc(saliency_absol); title('saliency absol'); colormap gray; colorbar;

% plot the tile of the activation
figure(2); clf; 
subplot(2,2,1); vl_imarraysc(saliency_map); colormap gray; title('saliency maps');
subplot(2,2,2); vl_imarraysc(feature_map); colormap gray; title('feature maps');
subplot(2,2,3); imagesc(im); title('original');