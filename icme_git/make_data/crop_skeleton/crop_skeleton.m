% This file is for crop skeleton to several skeletons to solve the
% problem of lack of GPU memory.

% image_make;

image_height = 300;
save_filedir = '../map_data/crop_skeleton';
source_label_dir = '/home/chh/icme/data/detection/Train_Label_PKU_final';
source_image_dir = '/home/chh/icme/data/detection/crop_skeleton/map_data';
source_image_train_dir = fullfile(source_image_dir, 'train_cs');
source_image_test_dir = fullfile(source_image_dir, 'test_cs');
save_label_dir = fullfile(save_filedir, 'crop_label');
save_image_train_dir = fullfile(save_filedir, 'crop_train_cs');
save_image_test_dir = fullfile(save_filedir, 'crop_test_cs');
if exist(save_filedir, 'dir')
    rmdir(save_filedir, 's')
end
mkdir(save_filedir)
mkdir(save_label_dir)
mkdir(save_image_train_dir)
mkdir(save_image_test_dir)
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
    
    [dire, name, ext] = fileparts(label_file);
    
    % train data
    if exist(fullfile(source_image_train_dir, [name '.png']))
        
        image = imread(fullfile(source_image_train_dir, [name '.png']));
        
        start_end(1, 1) = 1;
        start_end(crop_size, 2) = size(image, 2);
        
        for j = 1 : crop_size
            imwrite(image(:, start_end(j, 1) : start_end(j, 2), :), ...
                [save_image_train_dir, '/', name, '_', int2str(j), '.png']);
        end
        
        for j = 1 : crop_size
            create_label(image_height, start_end(j, 1), start_end(j, 2) - start_end(j, 1) + 1, ...
                [save_label_dir, '/', name, '_', int2str(j), '.xml'], ...
                data(divide_num(j) + 1 : divide_num(j + 1), :))
        end
        
        % test data
    else if exist(fullfile(source_image_test_dir, [name '.png']))
            image = imread(fullfile(source_image_test_dir, [name '.png']));
            
            start_end(1, 1) = 1;
            start_end(crop_size, 2) = size(image, 2);
            
            for j = 1 : crop_size
                imwrite(image(:, start_end(j, 1) : start_end(j, 2), :), ...
                    [save_image_test_dir, '/', name, '_', int2str(j), '.png']);
            end
            
            for j = 1 : crop_size
                create_label(image_height, start_end(j, 1), start_end(j, 2) - start_end(j, 1) + 1, ...
                    [save_label_dir, '/', name, '_', int2str(j), '.xml'], ...
                    data(divide_num(j) + 1 : divide_num(j + 1), :))
            end
        else
            error('error!!!!!!!!!!!!!!!!!')
        end
    end
    
    
end



