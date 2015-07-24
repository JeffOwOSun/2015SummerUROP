function saliency_map = saliency_extraction(net, im, classno, layer)
% net is the network
% im is normalized image
% labelno is the class number of the image
% layer is the number of the desired layer to extract dzdx value
% NOTE: the last layer of the supplied net must be loss layer
if (~strcmp(net.layers{end}.type,'softmaxloss'))
    if (strcmp(net.layers{end}.type, 'softmax'))
        net.layers{end}.type = 'softmaxloss';
    else
        net.layers{end+1} = struct('type', 'softmaxloss');
    end
end

% do a back prop
net.layers{end}.class = classno ;
dzdy = single(1);
res = vl_simplenn(net, im, dzdy);

%find dzdx of the first layer
saliency_map = res(layer).dzdx;