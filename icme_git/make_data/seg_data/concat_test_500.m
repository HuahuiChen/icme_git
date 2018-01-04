% concatenate results of image parts
% This file is for segment skeleton for improving mAP


% source_label_dir = '/home/chh/icme/data/detection/Train_Label_PKU_final';
source_part_result_dir = '/home/chh/faster-rcnn-resnet-master/result-oct/0.1-0.9';
save_label_txt_dir = '/home/chh/faster-rcnn-resnet-master/result-oct/test_part_result_concat_0.9';

if exist(save_label_txt_dir, 'dir')
    rmdir(save_label_txt_dir, 's')
end
mkdir(save_label_txt_dir)

seg_length = 100;
filename = dir([source_part_result_dir, '/*.txt']);

for i = 1 : size(filename, 1)
    i
    label_file = filename(i).name;
    label_file_full_img = strcat(label_file([1:3]), '.txt');
    part_num = (str2num(label_file(5))+str2num(label_file(6))*0.1)/0.1;    
    [dire, name, ext] = fileparts(label_file);    
    oct_of_create_full_label_txt_500(part_num * seg_length, fullfile(source_part_result_dir, label_file), fullfile(save_label_txt_dir, label_file_full_img));
end




