% concatenate results of image parts
% This file is for segment skeleton for improving mAP


source_label_dir = '/home/chh/icme/data/detection/Train_Label_PKU_final';
source_part_result_dir = '/home/chh/faster-rcnn-resnet-master/result/seg_500_0.01/cs_seg_500_0.01';
save_label_txt_dir = '/home/chh/faster-rcnn-resnet-master/result/seg_500_0.01/test_part_result_concat';

if exist(save_label_txt_dir, 'dir')
    rmdir(save_label_txt_dir, 's')
end
mkdir(save_label_txt_dir)

seg_length = 500;
filename = dir([source_part_result_dir, '/*.txt']);

for i = 1 : size(filename, 1)
    i
    label_file = filename(i).name;
    label_file_full_img = strcat(label_file([1:6]), '.txt');
    part_num = (str2num(label_file(8))+str2num(label_file(9))*0.1)/0.5;    
    [dire, name, ext] = fileparts(label_file);    
    create_full_label_txt(part_num * seg_length, fullfile(source_part_result_dir, label_file), fullfile(save_label_txt_dir, label_file_full_img));
end




