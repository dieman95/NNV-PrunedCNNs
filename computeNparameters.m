function parameters = computeNparameters(path_to_net)
load(path_to_net);
if contains(path_to_net,'pruned')
    n = length(nnP.Layers);
    params = zeros(1,n);
    for i=1:n
        if isa(nnP.Layers{i},'Conv2DLayer')
            d =  size(nnP.Layers{i}.Weights);
            params(i) = d(1)*d(2)*d(3)*d(4)+length(nnP.Layers{i}.Bias);
        elseif isa(nnP.Layers{i}, 'BatchNormalizationLayer')
            params(i) = 4*length(nnP.Layers{i}.Offset);
        elseif isa(nnP.Layers{i}, 'FullyConnectedLayer')
            d = size(nnP.Layers{i}.Weights);
            params(i) = d(1)*d(2) + length(nnP.Layers{i}.Bias);
        end
    end
else
    n = length(nn.Layers);
    params = zeros(1,n);
    for i=1:n
        if isa(nn.Layers{i}, 'Conv2DLayer')
            d =  size(nn.Layers{i}.Weights);
            params(i) = d(1)*d(2)*d(3)*d(4)+length(nn.Layers{i}.Bias);
        elseif isa(nn.Layers{i}, 'BatchNormalizationLayer')
            params(i) = 4*length(nn.Layers{i}.Offset);
        elseif isa(nn.Layers{i}, 'FullyConnectedLayer')
            d = size(nn.Layers{i}.Weights);
            params(i) = d(1)*d(2) + length(nn.Layers{i}.Bias);
        end
    end
end
parameters = sum(params);
end