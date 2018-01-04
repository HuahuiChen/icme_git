% mean = [189, 189, 216]
data_dir = '/home/chh/icme/data/detection/map_data/100.1024data/train_cs_100.1024';
filename = dir([data_dir '/*.png']);
mean_img = [0, 0, 0];
for i = 1 : length(filename)
    im = imread([data_dir '/' filename(i).name]);
    temp1 = sum(im, 1);
    temp2 = sum(temp1, 2);
    mean_img = mean_img + reshape(temp2, 1, 3);
    mean_img = mean_img / (size(im, 1) * size(im, 2));
end