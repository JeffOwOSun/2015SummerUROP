function projected_feature_map = feature_map_projection(net, im, layerno)

%% modify the net: remove all layers beginning from layerno
net.layers = net.layers(1:layerno-1);
%% do a forward prop, get the result
res = vl_simplenn(net, im);
%% pre allocate return value
[width, height, ~] = size(im);
quantity = size(res(end).x, 3);
projected_feature_map = zeros(width, height, 3, quantity);
%% project every feature map
for fmapno = 1:quantity % for each fmapno
    disp(['generating layer: ',num2str(fmapno)]);
    dzdy = single(zeros(size(res(end).x))); %bunch of zero
    dzdy(:,:,fmapno) = res(end).x(:,:,fmapno); %replace feature map
    projected_feature_map(:,:,:,fmapno) = project_fmap(net, im, dzdy); %the return value
end

function projected_feature_map = project_fmap(net, im, dzdy)
% project fmap down to input image space

% do a back prop, get the result
res = vl_simplenn(net, im, dzdy);
projected_feature_map = res(1).dzdx;