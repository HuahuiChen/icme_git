% create skeleton detection label like PASCAL
% Huahui Chen, 2017.3.24

source_data_dir = '/home/chh/icme/data/detection/PKU_Skeleton_Renew';
source_label_dir = '/home/chh/icme/data/detection/Train_Label_PKU_final';
dest_label_dir = '/home/chh/icme/data/detection/detection_label';


source_label_total_filename = dir([source_label_dir '/*.txt']);
pic_height = 512;
pic_width = 512;
pic_channel = 3;
parfor i = 1 : length(source_label_total_filename)
    i
    filename = source_label_total_filename(i).name;
    [a, filename_nopost, post] = fileparts(filename);
    fid_dest = fopen([dest_label_dir '/' filename_nopost '.xml'], 'w');
    
    fid_source = fopen([source_data_dir '/' filename_nopost '.txt']);
    frame_num = 0;
    while(fgetl(fid_source) ~= -1)
        frame_num = frame_num + 1;

    end
    
    
    fprintf(fid_dest, '<annotation>\n');
    fprintf(fid_dest, '\t<filename>%s.png</filename>\n', filename_nopost);
    fprintf(fid_dest, '\t<folder>skeleton</folder>\n');
    
    objects = csvread([source_label_dir '/' filename_nopost '.txt']);
    for j = 1 : length(objects)
        fprintf(fid_dest, '\t<object>\n');
        fprintf(fid_dest, '\t\t<name>%d</name>\n', objects(j, 1));
        fprintf(fid_dest, '\t\t<bndbox>\n');
        fprintf(fid_dest, '\t\t\t<xmax>%d</xmax>\n', uint16(objects(j, 3) / frame_num * pic_width));
        fprintf(fid_dest, '\t\t\t<xmin>%d</xmin>\n', uint16(objects(j, 2) / frame_num * pic_width));
        fprintf(fid_dest, '\t\t\t<ymax>%d</ymax>\n', pic_height);
        fprintf(fid_dest, '\t\t\t<ymin>%d</ymin>\n', 1);
        fprintf(fid_dest, '\t\t</bndbox>\n');
        fprintf(fid_dest, '\t</object>\n');
    end
    
    fprintf(fid_dest, '\t<size>\n');
    fprintf(fid_dest, '\t\t<depth>%d</depth>\n', pic_channel);
    fprintf(fid_dest, '\t\t<height>%d</height>\n', pic_height);
    fprintf(fid_dest, '\t\t<width>%d</width>\n', pic_width);
    fprintf(fid_dest, '\t</size>\n');
    
    fprintf(fid_dest, '</annotation>');
    
    fclose(fid_dest);
end