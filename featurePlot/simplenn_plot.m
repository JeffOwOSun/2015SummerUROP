function [img,filename] = simplenn_plot(res, layer, no, plotnow)
% VL_SIMPLENN_PLOT Plots the feature extraction output in the res array
%   IMG = VL_SIMPLENN_PLOT(RES) Plot the feature extracted
%   normalize_mean = the middle point for normalization
%   normalize_range = the range for normalization

img = res(layer).x(:,:,no);
filename = sprintf('layer:%d_no:%d.png', layer, no);
if plotnow
    image(img, 'CDataMapping', 'scaled'); colorbar;
    title(filename);
end
