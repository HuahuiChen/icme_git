video_dir = '/home/chh/icme/data/detection/PKU_Skeleton_Renew';
length_dir = '/home/chh/icme/data/detection/Skeleton_Length';
video = dir([video_dir '/*.txt']);

for i = 1 : size(video)
    i
    length = 0;
    fid = fopen([video_dir '/' video(i).name]);
    while(fgetl(fid) ~= -1)
        length = length + 1;
    end
    fclose(fid);
    fid = fopen([length_dir '/' video(i).name], 'w');
    fprintf(fid, '%d', length);
    fclose(fid);
end
    