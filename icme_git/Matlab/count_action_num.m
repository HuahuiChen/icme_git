% This file is written for count the number of action (60 classes)
% of training and test samples

% create skeleton detection label like PASCAL
% Huahui Chen, 2017.3.24

source_label_dir = '/home/chh/icme/data/detection/Train_Label_PKU_final';


source_label_total_filename = dir([source_label_dir '/*.txt']);
train_start = [1, 855 + 132];
train_end = [854, 1076];
test_start = [855]
test_end = [855 + 131];

% store number of training and test action. Each column represents one
% action number
train_num = zeros(1, 60); 
test_num = zeros(1, 60);

% count training number
for i = 1 : length(train_start)
    for j = train_start(i) : train_end(i)
        j
        filename = source_label_total_filename(j).name;
        [a, filename_nopost, post] = fileparts(filename);
        objects = csvread([source_label_dir '/' filename_nopost '.txt']);
        for k = 1 : length(objects)
            train_num(objects(k, 1)) = train_num(objects(k,1)) + 1;
        end
    end
end

% count test number
for i = 1 : length(test_start)
    for j = test_start(i) : test_end(i)
        j
        filename = source_label_total_filename(j).name;
        [a, filename_nopost, post] = fileparts(filename);
        objects = csvread([source_label_dir '/' filename_nopost '.txt']);
        for k = 1 : length(objects)
            test_num(objects(k, 1)) = test_num(objects(k,1)) + 1;
        end
    end
end
