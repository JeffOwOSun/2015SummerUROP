function initializeimdb

% setup
setup

% set dir
female_dir = 'lfw-gender/female';
male_dir = 'lfw-gender/male';

% load images
female_imarray = load_jpg_dir(female_dir);
male_imarray = load_jpg_dir(male_dir);
% set labels
female_labels = cell(size(female_imarray));
female_labels(:) = {0};
male_labels = cell(size(male_imarray));
male_labels(:) = {1};

imdb.images.data = cat(4, female_imarray{:} ,male_imarray{:});
imdb.images.label = cat(1, female_labels{:}, male_labels{:});
imdb.images.id = transpose(1:numel(imdb.images.label));
%TODO set set

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
