% This file is for crop skeleton to several skeletons to solve the
% problem of lack of GPU memory.


save_filedir = '../map_data/crop_skeleton';
source_label_dir = '/home/chh/icme/data/detection/Train_Label_PKU_final';
save_label_txt_dir = fullfile(save_filedir, 'crop_label_txt');

if exist(save_label_txt_dir)
    rmdir(save_label_txt_dir, 's')
end
mkdir(save_label_txt_dir)

crop_size = 5; % divide to crop_size parts

filename = dir([source_label_dir, '/*.txt']);

for i = 1 : size(filename, 1)
    i
    label_file = filename(i).name;
    data = csvread(fullfile(source_label_dir, label_file));
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

    for j = 1 : crop_size
        create_label_txt(start_end(j, 1), start_end(j, 2) - start_end(j, 1) + 1, ...
            [save_label_txt_dir, '/', name, '_', int2str(j), '.txt'], ...
            data(divide_num(j) + 1 : divide_num(j + 1), :))
    end
end




