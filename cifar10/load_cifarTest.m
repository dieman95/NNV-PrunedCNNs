function All_img = load_cifarTest(varargin)
% Input: true or false (default)
% True: returns normalized images
% False: returns true data
if nargin == 0
    process = true;
elseif nargin == 1
    process = varargin{1};
else
    error('Wrong number of inputs')
end
% Load all images with corresponding targets (CIFAR)
category = ["airplane","automobile","bird","cat","deer","dog","frog","horse","ship","truck"];
All_img = zeros(10000,32,32,3); % memory allocation
% Load all test images
for k=1:length(category)
    categ =char(category(k));
    pth = ['/home/dieman95/Documents/MATLAB/importNetworks/datasets/cifar10Test/' categ '/*.png'];
    images = dir(pth);
    m = length(images);
    for i=1:m
        if process == true
            All_img((k-1)*1000+i,:,:,:) = readCifarImage(['/home/dieman95/Documents/MATLAB/importNetworks/datasets/cifar10Test/' categ '/' images(i).name]);
        elseif process == false
            All_img((k-1)*1000+i,:,:,:) = double(imread(['/home/dieman95/Documents/MATLAB/importNetworks/datasets/cifar10Test/' categ '/' images(i).name]));
        end
    end
end