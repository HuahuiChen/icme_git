% concatenate results of image parts
% This file is for crop skeleton to several skeletons to solve the
% problem of lack of GPU memory.


source_label_dir = '/home/chh/icme/data/detection/Train_Label_PKU_final';
source_part_result_dir = '/home/chh/data/VOCdevkit/results/VOC2007/SSD_1000x300_source_image_part_cs_add_ratio_backup/test_part_result';
save_label_txt_dir = '/home/chh/data/VOCdevkit/results/VOC2007/SSD_1000x300_source_image_part_cs_add_ratio_backup/test_part_result_concat';

if exist(save_label_txt_dir, 'dir')
    rmdir(save_label_txt_dir, 's')
end
mkdir(save_label_txt_dir)

crop_size = 5; % divide to crop_size parts

filename = dir([source_part_result_dir, '/*.txt']);

for i = 1 : size(filename, 1)
    i
    label_file = filename(i).name;
    label_file_full_img = strcat(label_file([1:6]), '.txt');
    part_num = str2num(label_file(8));
    data = csvread(fullfile(source_label_dir, label_file_full_img));
    yushu = mod(size(data, 1), crop_size);
    shang = floor(size(data, 1) / crop_size);
    divide_num = shang * ones(1, crop_size);
    for j = 1 : yushu
        divide_num(j) = shang + 1;
    end
    divide_num = cumsum(divide_num);
    divide_num = [0, divide_num];
    
    for j = 1 : crop_size
        start_end(j, 1) = data(divide_num(j) + 1, 2);
        start_end(j, 2) = data(divide_num(j + 1), 3);
    end
    for j = 1 : crop_size - 1
        start_end(j, 2) = floor((start_end(j, 2) + start_end(j + 1, 1)) / 2);
        start_end(j + 1, 1) = start_end(j, 2) + 1;
    end
    start_end(1, 1) = 1;
    start_end(crop_size, 2) = size(image, 2);    
    [dire, name, ext] = fileparts(label_file);    
    create_full_label_txt(start_end(part_num, 1), fullfile(source_part_result_dir, label_file), fullfile(save_label_txt_dir, label_file_full_img));
end




