function [net, info] = gender_classification(varargin);
setup

opts.expDir = fullfile('data', 'gender_classification');
[opts, varargin] = vl_argparse(opts, varargin);

%opts.dataDir = fullfile('data', 'lfw-gender');
opts.imdbPath = 'imdb.mat';
opts.useBnorm = false;
opts.train.batchSize = 100;
opts.train.numEpochs = 20;
opts.train.continue = true;
opts.train.gpus = 1;
opts.train.learningRate = 0.001;
opts.train.expDir = opts.expDir;
opts = vl_argparse(opts. varargin);

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

% --------------------------------------------------------------------
%                                                                Train
% --------------------------------------------------------------------

[net, info] = cnn_train(net, imdb, @getBatch, ...
    opts.train) ;

% --------------------------------------------------------------------
function [im, labels] = getBatch(imdb, batch)
% --------------------------------------------------------------------
im = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(batch) ;