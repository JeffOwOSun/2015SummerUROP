function net = initialize_net(varargin)
opts.scale = 1;
opts = vl_argparse(opts, varargin);

% load vgg net
net = load('imagenet-vgg-f.mat');

% replace the last layers
net.layers{20}.weights={0.01/opts.scale * randn(1, 1, 4096, 2, 'single'), []};
net.layers{21} = struct('type', 'softmaxloss', 'name', 'loss');

% set the classes
net.classes.name = {'female', 'male'};
net.description = {'female', 'male'};