%% Initialization
clear all
clc

%% Compute residual image between channel 30 and 31 (I_31 - I_30)
path_1 = [cd '\Channel_30\'];
filenames_1 = dir(path_1)

path_2 = [cd '\Channel_31\'];
filenames_2 = dir(path_2)

path = [cd '\Channel_30_31_Residual\'];


for i = 3:length(filenames_1)
    i
    I_30 = imread([path_1 filenames_1(i).name]);
    I_31 = imread([path_2 filenames_2(i).name]);
    I = double(I_31) - double(I_30);
    imwrite(I, [path filenames_1(i).name]);
end