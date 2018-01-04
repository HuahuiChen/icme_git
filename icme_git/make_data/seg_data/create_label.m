% create skeleton detection label like PASCAL
% Huahui Chen, 2017.3.24
function[] = create_label(pic_height, pic_start, pic_width, save_filename, bbox)

pic_channel = 3;

[a, filename_nopost, post] = fileparts(save_filename);
fid_dest = fopen(save_filename, 'w');

frame_num = pic_width;


fprintf(fid_dest, '<annotation>\n');
fprintf(fid_dest, '\t<filename>%s.png</filename>\n', filename_nopost);
fprintf(fid_dest, '\t<folder>skeleton</folder>\n');

objects = bbox;
objects(:, 2) = objects(:, 2) - pic_start + 1;
objects(:, 3) = objects(:, 3) - pic_start + 1;
for j = 1 : size(objects, 1)
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