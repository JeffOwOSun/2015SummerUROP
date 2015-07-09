function img = vl_simplenn_plot(res, layer, no, plotnow)
% VL_SIMPLENN_PLOT Plots the feature extraction output in the res array
%   IMG = VL_SIMPLENN_PLOT(RES) Plot the feature extracted

img = res(layer).x(:,:,no);
if plotnow
    image(img, 'CDataMapping', 'scaled'); colorbar;
end
