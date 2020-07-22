%% Test networks and create new ones without unnecessary layers
% Load networks (vgg16 and pruned vgg16)
net = importONNXNetwork('../../Pruned/l1-norm/vgg19/vgg19.onnx','OutputLayerType','classification');
netP = importONNXNetwork('../../Pruned/l1-norm/vgg19/vgg19pruned.onnx','OutputLayerType','classification');
% Test the networks
addpath('../../datasets');
acc = testCifar10(net);
accP = testCifar10(netP);

%% Unpruned network
% Delete unnecessary layers (flatten layers)
j = 1;
flattenLayers = {};
for i=1:length(net.Layers)
    if contains(class(net.Layers(i)),'FlattenLayer')
        flattenLayers{j} = net.Layers(i).Name;
        j = j + 1;
    end
end
lgraph = layerGraph(net.Layers);
lgraph = removeLayers(lgraph,flattenLayers);
net_new = SeriesNetwork(lgraph.Layers);
% Parse them for NNV
nn = CNN.parse(net_new);
acc_new = testCifar10(net_new);
% We get the exact same accuracy when removing the flattenLayers

%% Pruned network
% Delete unnecessary layers (flatten layers)
j = 1;
flattenLayersP = {};
for i=1:length(netP.Layers)
    if contains(class(netP.Layers(i)),'FlattenLayer')
        flattenLayersP{j} = netP.Layers(i).Name;
        j = j + 1;
    end
end
lgraph = layerGraph(netP.Layers);
lgraph = removeLayers(lgraph,flattenLayersP);
netP_new = SeriesNetwork(lgraph.Layers);
% Parse them for NNV
nnP = CNN.parse(netP_new);
accP_new = testCifar10(netP_new);
% We get the exact same accuracy when removing the flattenLayers

%% Save the converted networks
save('vgg19nnv.mat','nn');
save('vgg19nnv_pruned.mat','nnP');