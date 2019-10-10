%% 清空环境变量
clear all
clc

%% 导入数据
imagesDir = '.';
trainInputDir = fullfile(imagesDir,'Channel_30');
exts = {'.jpg','.bmp','.png'};
trainInput = imageDatastore(trainInputDir,'FileExtensions',exts);
trainInput.ReadFcn = @(trainInput)imread(trainInput);

imagesDir = '.';
trainOutputDir = fullfile(imagesDir,'Channel_Residual_30_31');
exts = {'.jpg','.bmp','.png'};
trainOutput = imageDatastore(trainOutputDir,'FileExtensions',exts);
trainOutput.ReadFcn = @(trainOutput)imread(trainOutput);

%% add data augmentation
augmenter = imageDataAugmenter( ...
    'RandRotation',@()randi([0,1],1)*90, ...
    'RandXReflection',true);

%% patch datastore time!
miniBatchSize = 20;
patchSize = [16 16];
patchds = randomPatchExtractionDatastore(trainInput,trainOutput,patchSize, ....
    'PatchesPerImage',500, ...
    'DataAugmentation',augmenter);
patchds.MiniBatchSize = miniBatchSize;

%% training time!
load net.mat

options = trainingOptions('adam','InitialLearnRate',1e-4,'MiniBatchSize',10,...
        'Shuffle','never','MaxEpochs',10,...
        'Plots','training-progress');
    
%% Train!!
% this takes quite a while, (around 40 minutesto complete training)
net = trainNetwork(patchds,lgraph,options);

%% Predict
test_Image = imread('Test\fake_and_real_beers_ms_30.png');
test_Image = imresize(test_Image,[256 256]);

predict_Image = activations(net,test_Image,'regressionLayer');

true_Image = imread('Test\fake_and_real_beers_ms_31.png');
true_Image = imresize(true_Image,[256 256]);


ssimval = ssim(uint16(predict_Image)+test_Image,true_Image)

