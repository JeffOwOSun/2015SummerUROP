function imdb = initializeimdb

%% setup
setup

% set dir
female_dir = 'lfw-gender/female';
male_dir = 'lfw-gender/male';

%% load images
female_imarray = load_jpg_dir(female_dir);
male_imarray = load_jpg_dir(male_dir);
%% even the number of images
% here first param for randperm is the range it permutes
% the second param is the number of indices it should return
female_imarray = female_imarray{randperm(numel(female_imarray), numel(male_imarray))};

%% set labels
% female -> 0
% male -> 1
female_labels = zeros(1, numel(female_imarray));
male_labels = ones(1, numel(male_imarray)); 
labels = [female_labels male_labels];
%% set set
female_set = ones(1, numel(female_imarray));
val_index = randperm(numel(female_set)); % index of validation sets
val_index = val_index(1:numel(val_index)/5);
female_set(val_index) = 2; % validation set
male_set = ones(1, numel(male_imarray));
val_index = randperm(numel(male_set));
val_index = val_index(1:numel(val_index)/5);
male_set(val_index) = 2;
set = [female_set, male_set];
%% normalize images
data = cat(4, female_imarray{:} ,male_imarray{:});
dataMean = mean(data(:,:,:,set == 1), 4);
data = bsxfun(@minus, data, dataMean);
%% set the return values
imdb.images.data = data;
imdb.images.labels = labels;
imdb.images.set = set;
imdb.meta.sets = {'train', 'val', 'test'};
imdb.meta.classes = {'female', 'male'}; % I guessed so

function imarray = load_jpg_dir(dir)
% load images
impaths = ls(dir);
impaths = num2cell(impaths, 2);
impaths = cellfun(@strtrim, impaths, 'UniformOutput', false);
impaths = fullfile(dir, impaths);
% filter invalid paths
imidx = ~cellfun(@isempty, strfind(impaths, '.jpg'));
impaths = impaths(imidx);
% load images
imarray = vl_imreadjpeg(impaths);
