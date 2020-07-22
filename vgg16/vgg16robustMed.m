%% Load networks
load('vgg16nnv.mat');
load('vgg16nnv_pruned');

% Note: label = 1   --> airplane
%           label = 2   --> automobile
%           label = 3   --> bird
%           label = 4   --> cat
%           label = 5   --> deer
%           label = 6   --> dog
%           label = 7   --> frog
%           label = 8   --> horse
%           label = 9   --> ship
%           label = 10 --> truck

% Load images
n = 500; % Number of images to test (ideally n/10 of each class)
seed = 20; % Set random seed to select images
images = load_cifarTest;
% Images to pick
rng(seed); % Set seed
im = randi([1 10000],1,n);
% Set target labels for each image
im_targets = ceil(im./1000);
% Test images 
test_IM = images(im,:,:,:);
% Raw data (unprocessed)
% raw_IM = load_cifarTest(false);
% raw_IM = raw_IM(im,:,:,:);

% Check what images the networks correctly classify (need to change the
% targets, these are wrong now)
class_nn = zeros(1,100); % classification labels for the unpruned network
class_nnP = zeros(1,100); % classification labels for the pruned network
for i=1:n
    img = reshape(images(im(i),:,:,:),[32,32,3]); % Prepare image
    class_nn(i) = nn.classify(img); %classification labels
    class_nnP(i) = nnP.classify(img); %classification labels
end
% Correctly classified
cor_nn = class_nn == im_targets;
cor_nnP = class_nnP == im_targets;
% Accuracy
% acc_nn = sum(cor_nn)/100;
% acc_nnP = sum(cor_nn)/100;

%% Analysis
% For testing
% delta = [0.005 0.01 0.015]; % bmax - delta = treshold for brightening attack
delta = 0.01;
bmax = [2.514087988136431, 2.596790371113340, 2.753731343283582]; % max values for channel [1,2,3]
pixel_attack = [];
inputSetStar = cell(1,n);

for i=1:n
    inputStar = [];
    for c=1:3
        IM = test_IM(i,:,:,c);
        lb = IM;
        ub = IM;
        for p=1:1024
            if  IM(p) >= (bmax(c)-delta)
                icp = [i;c;p]; % [Image number, channel, pixel]
                pixel_attack = [pixel_attack icp];
                lb(p) = IM(p);
                ub(p) = bmax(c);
            end
        end
        lb = reshape(lb,[32,32]);
        ub = reshape(ub,[32,32]);
        LB(:,:,c) = lb;
        UB(:,:,c) = ub;
    end
    S = ImageStar(LB,UB);
    inputSetStar{i} = S;
end       

%% Evaluate robustness
n2 = 500; % Number of attacked images to verify
VT_nn = zeros(1, n2); % verification time of the approx-star method
VT_nnP = zeros(1, n2); % verification time of the approx-star method
r_nn = zeros(1, n2); % robustness percentage on an array of N tested input sets obtained by the approx-star method
r_nnP = zeros(1, n2); % robustness percentage on an array of N tested input sets obtained by the approx-star method
c = parcluster('local');
numCores = c.NumWorkers; % specify number of cores used for verification
skipped=[];

% Evaluation using approx-star method (timeout 0f 2 minutes for each image)
for i=1:n2
    if sum(pixel_attack(1,:) == i) < 80 && sum(pixel_attack(1,:) == i) > 20 && i~= 367
        t = tic;
        r_nn(i) = nn.verifyRobustness(inputSetStar{i}, im_targets(i), 'approx-star', numCores);
        VT_nn(i) = toc(t);
        t = tic;
        r_nnP(i) = nnP.verifyRobustness(inputSetStar{i}, im_targets(i), 'approx-star', numCores);
        VT_nnP(i) = toc(t);
    else
        r_nn(i) = -1; % Timeout
        r_nnP(i) = -1; % Timeout
        VT_nn(i) = -1;
        VT_nnP(i) = -1;
        disp('Image ' + string(i) + ' is skipped');
        skipped = [skipped i];
    end
end

%% Check results
% From the pictures fully analyzed
anlz = r_nn >= -0.5;
skN = length(skipped);
acc_nn = sum(cor_nn.*anlz)/(n-skN);
acc_nnP = sum(cor_nnP.*anlz)/(n-skN);
% Unpruned
% disp('============================');
% disp('=====  Unpruned Network  ==========');
% disp('============================');
% disp('Total number of images analyzed = ' + string(n-skN));
% disp('Accuracy: ' + string(sum(cor_nn.*anlz)) + '/' + (string(n-skN)) + ' = ' + string(acc_nn));
% disp('Robust: ' + string(sum(r_nn==1)));
% disp('Unknown: ' + string(sum(r_nn==2)));
tC_nn = VT_nn.*(VT_nn > -0.5);
% disp('Total time: ' + string(sum(tC)) + ' seconds');
% disp('Average time per image: ' + string(sum(tC)/(n-skN)) + 'seconds');

% Pruned
% disp('============================')
% disp('=====  Pruned Network  ==========');
% disp('============================')
% disp('Total number of images analyzed = ' + string(n-skN));
% disp('Accuracy: ' + string(sum(cor_nnP.*anlz)) + '/' + (string(n-skN)) + ' = ' + string(acc_nnP));
% disp('Robust: ' + string(sum(r_nnP==1)));
% disp('Unknown: ' + string(sum(r_nnP==2)));
tC_nnP = VT_nnP.*(VT_nnP > -0.5);
% disp('Total time: ' + string(sum(tC)) + ' seconds');
% disp('Average time per image: ' + string(sum(tC)/(n-skN)) + 'seconds');
save('vgg16resultsMed');