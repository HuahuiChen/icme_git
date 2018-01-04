% create skeleton detection label like PASCAL
% Huahui Chen, 2017.3.24
function[] = create_full_label_txt(pic_start, source_part_filename, save_filename)

data = load(source_part_filename);
fid_save = fopen(save_filename, 'a');
for i = 1 : size(data, 1)
    fprintf(fid_save, '%d,%d,%d,%.4f\n', data(i, 1), uint16(data(i, 2) + pic_start - 1), uint16(data(i, 3) + pic_start - 1), data(i, 4));
end
fclose(fid_save);
end