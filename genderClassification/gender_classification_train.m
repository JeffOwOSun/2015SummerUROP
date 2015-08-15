function [net, info] = gender_classification_train(varargin)
setup

opts.expDir = fullfile('D:', 'gender_classification'); % store on hdd to cater larger space
[opts, varargin] = vl_argparse(opts, varargin);

%opts.dataDir = fullfile('data', 'lfw-gender');
opts.imdbPath = 'imdb.mat'; % store on ssd to provide fast access
opts.useBnorm = false;
opts.train.batchSize = 100;
opts.train.numEpochs = 300;
opts.train.continue = true;
opts.train.gpus = 1;
opts.train.learningRate = 0.0001;
opts.train.expDir = opts.expDir;
opts.train.backPropDepth = 6; % only update the fresh two layers
opts = vl_argparse(opts, varargin);

% --------------------------------------------------------------------
%                                                         Prepare data
% --------------------------------------------------------------------

if exist(opts.imdbPath, 'file')
  imdb = load(opts.imdbPath) ;
else
  imdb = initializeimdb;
  save(opts.imdbPath, '-struct', 'imdb' ,'-v7.3') ;
end

net = initialize_net;
averageImage = net.normalization.averageImage;
imdb.images.data = bsxfun(@minus, imdb.images.data, averageImage);

% --------------------------------------------------------------------
%                                                                Train
% --------------------------------------------------------------------

[net, info] = cnn_train(net, imdb, @getBatchWithJitter, ...
    opts.train) ;
% save the network for later use
net.layers(end) = [];
save('gender-classification-vgg-f.mat', '-struct', 'net', '-v7.3');
% --------------------------------------------------------------------
function [im, labels] = getBatch(imdb, batch)
% --------------------------------------------------------------------
im = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(batch) ;

% --------------------------------------------------------------------
function [im, labels] = getBatchWithJitter(imdb, batch)
% --------------------------------------------------------------------
im = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(batch) ;

%figure(100); clf;
%subplot(2,1,1); vl_imarraysc(im);

% random shifting the image
Xshift = randi(40, 1, numel(batch)) - 20;
Yshift = randi(40, 1, numel(batch)) - 20;
im = arrayfun(@(i, x, y) imtranslate(im(:,:,:,i), [x y], 'FillValues', 0), 1:numel(batch), Xshift, Yshift, 'UniformOutput', false);
im = cat(4, im{:});
% add noise
% im = arrayfun(@(i) imnoise(im(:,:,:,i), 'gaussian'), 1:numel(batch), 'UniformOutput', false);
% im = cat(4, im{:});

%subplot(2,1,2); vl_imarraysc(im);