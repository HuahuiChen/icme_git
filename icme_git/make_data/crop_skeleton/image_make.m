
% create submit image
close all
clc
clear
dir_name = '/home/chh/icme/data/detection/PKU_Skeleton_Renew/';

resize_height = 300;
resize_width = [];


train_obj_name = '/home/chh/icme/data/detection/crop_skeleton/map_data/train_cs/';
list_name = importdata('/home/chh/icme/data/detection/train-cross-subject.txt');

parfor i = 1 : length(list_name)
    i
    
    name = list_name{i};
    name=[name,'.txt'];
    resize_width = load(fullfile('/home/chh/icme/data/detection/Skeleton_Length',name));
    filename = [dir_name,name];
    img = create_map(filename, resize_height, resize_width);
    name=name(1:6);
%     d=[obj_name,name];
    imwrite(img,[train_obj_name,name,'.png']);    
end

test_obj_name = '/home/chh/icme/data/detection/crop_skeleton/map_data/test_cs/';
list_name = importdata('/home/chh/icme/data/detection/test-cross-subject.txt');
parfor i = 1 : length(list_name)
    i
    name = list_name{i};
    name=[name,'.txt'];
    resize_width = load(fullfile('/home/chh/icme/data/detection/Skeleton_Length',name));
    filename = [dir_name,name];
    img = create_map(filename, resize_height, resize_width);
    name=name(1:6);
%     d=[obj_name,name];
    imwrite(img,[test_obj_name,name,'.png']);    
end