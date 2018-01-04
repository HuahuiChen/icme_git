% This file is for segment skeleton to several skeletons to improve
% detection mAP.

% image_make;

image_height = 300;
save_filedir = '/home/chh/faster-rcnn-resnet-master/0097-R';
source_label_dir = '/home/chh/icme/data/detection/Train_Label_PKU_final';
source_image_dir = '/home/chh/icme/data/detection/seg_skeleton/map_data';
source_image_test_dir = fullfile(source_image_dir, 'train_cs');
save_label_dir = fullfile(save_filedir, 'seg_label');
save_image_test_dir = fullfile(save_filedir, 'seg_test_500_cs');
if exist(save_filedir, 'dir')
    rmdir(save_filedir, 's')
end
mkdir(save_filedir)
mkdir(save_label_dir)
mkdir(save_image_test_dir)

seg_length = 500;
seg_inteval = 100;

filename = dir([source_label_dir, '/*.txt']);

% for i = 1 : size(filename, 1)
for i = 1:1
    i
    label_file = '0097-R.txt';
    data = csvread(fullfile(source_label_dir, label_file));
    [dire, name, ext] = fileparts(label_file);
    if exist(fullfile(source_image_test_dir, [name '.png']))
        image = imread(fullfile(source_image_test_dir, [name '.png']));
        image_length = size(image, 2);
        if mod(image_length - seg_length, seg_inteval) < seg_inteval / 2
            seg_num = floor((image_length - seg_length) / seg_inteval) + 1;
        else
            seg_num = floor((image_length - seg_length) / seg_inteval) + 2;
        end
        
        %part1: 1 to (seg_num - 1) images
        for seg_cnt = 1 : seg_num - 1
            seg_start = seg_inteval * seg_cnt - seg_inteval + 1;
            seg_end = seg_inteval * seg_cnt  - seg_inteval + seg_length;
            
            
            % write label
            for k = 1 : size(data, 1)
                if data(k, 2) >= seg_start
                    label_start_ind = k;
                    break;
                end
            end
            if k == size(data, 1) & data(k, 2) < seg_start
                %                     error('error for label index start')
                continue;
            end
            
            for k = size(data, 1) : -1 : 1
                if data(k, 3) <= seg_end
                    label_end_ind = k;
                    break;
                end
            end
            if k == 1 & data(k, 3) > seg_end
                %                     error('error for label index end')
                continue;
            end
            % write image
            imwrite(image(:, seg_start : seg_end, :), ...
                [save_image_test_dir, '/', name, '_', num2str(seg_start, '%04d'),...
                '_', num2str(seg_end, '%04d'), '.png']);
            create_label(image_height, seg_start, seg_end - seg_start + 1, ...
                [save_label_dir, '/', name, '_', num2str(seg_start, '%04d'),...
                '_', num2str(seg_end, '%04d'), '.xml'], data(label_start_ind : label_end_ind, :));
        end
        
        % part2: last image
        seg_start = seg_start + seg_inteval;
        seg_end = image_length;
        % write image
        
        
        % write label
        for k = 1 : size(data, 1)
            if data(k, 2) >= seg_start
                label_start_ind = k;
                break;
            end
        end
        if k == size(data, 1) & data(k, 2) < seg_start
            %                 error('error for label index start')
            continue;
        end
        
        for k = size(data, 1) : -1 : 1
            if data(k, 3) <= seg_end
                label_end_ind = k;
                break;
            end
        end
        if k == 1 & data(k, 3) > seg_end
            %                 error('error for label index end')
            continue;
        end
        imwrite(image(:, seg_start : seg_end, :), ...
            [save_image_test_dir, '/', name, '_', num2str(seg_start, '%04d'),...
            '_', num2str(seg_end, '%04d'), '.png']);
        create_label(image_height, seg_start, seg_end - seg_start + 1, ...
            [save_label_dir, '/', name, '_', num2str(seg_start, '%04d'),...
            '_', num2str(seg_end, '%04d'), '.xml'], data(label_start_ind : label_end_ind, :));
        
    else
        disp('ignore train')
    end
end
