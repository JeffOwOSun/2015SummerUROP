%% setup matconvnet and vlfeat
run setup.m;

%% load network
net_vgg = 'imagenet-vgg-f.mat';
net_alex = 'imagenet-caffe-alex.mat';
% I choose alex
net = load(net_vgg);

%% load Image
% index of desired image
imno = 2;
load('imdb.mat');
im = imread(imdb(imno).name);
% pre-process image
im_ = single(im);
im_ = imresize(im_, net.normalization.imageSize(1:2));
im_ = im_ - net.normalization.averageImage;

%% set layernumber
layerno = 2; % look at the INPUT of 16-th layer

%% extract saliency
[saliency_map, feature_map] = saliency_extraction(net, im_, imdb(imno).class, layerno); % a map for each channel

%% project the feature maps
projected_fmap = feature_map_projection(net, im_, layerno);

%% calculate the average of the activation
% saliency_absol = abs(saliency_map);
% saliency_absol = max(saliency_absol,[],3);
% % take the norm of the 3D saliency map for each pixel
% saliency_norm = sqrt(sum(saliency_map .^ 2,3));

%% display original image
figure(1); clf;
imagesc(im); title('original');

%% plot the results
figure(2); clf; 
subplot(2,2,1); vl_imarraysc(saliency_map); colormap gray; title('saliency maps');
subplot(2,2,2); vl_imarraysc(feature_map); colormap gray; title('feature maps');
subplot(2,2,3); vl_imarraysc(projected_fmap); title('fmap projection');
subplot(2,2,4); imagesc(im); title('original');