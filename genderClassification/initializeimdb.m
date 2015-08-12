function imdb = initializeimdb

% setup
setup

% set dir
female_dir = 'lfw-gender/female';
male_dir = 'lfw-gender/male';

% load images
female_imarray = load_jpg_dir(female_dir);
male_imarray = load_jpg_dir(male_dir);
% TODO: normalize images
% set labels
female_labels = zeros(1, numel(female_imarray));
male_labels = ones(1, numel(male_imarray)); 
% set set
female_set = ones(1, numel(female_imarray));
val_index = randperm(numel(female_set)); % index of validation sets
val_index = val_index(1:numel(val_index)/5);
female_set(val_index) = 2; % validation set
male_set = ones(1, numel(male_imarray));
val_index = randperm(numel(male_set));
val_index = val_index(1:numel(val_index)/5);
male_set(val_index) = 2;

imdb.images.data = cat(4, female_imarray{:} ,male_imarray{:});
imdb.images.label = [female_labels male_labels];
imdb.images.id = 1:numel(imdb.images.label);
imdb.images.set = [female_set, male_set];

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
