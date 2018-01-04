% encode 3D skeleton to 2D image, edited by Huahui Chen, 2017.3.13
% Encode contains project from various views, direction(Hue),
% body parts(colormap), speed(Saturation, Brightness)

close all

% filename = '/home/chh/icme/nturgb+d_skeletons/S003C003P019R002A054.skeleton';
dir_name = '/home/chh/icme/nturgb+d_skeletons/';
read_dir = dir([dir_name '*.skeleton']);
write_dir = '/home/chh/icme/data_encode/';

parfor i = 1 : length(read_dir)
%     filename = 'S017C003P008R002A059.skeleton';
    filename = read_dir(i).name
    bodyinfor = read_skeleton_file([dir_name filename]);
    
    view_num = 3;
    % project skeleton to view_num planes;
    image_project = proj_skeleton(bodyinfor); % note this return hsv image
    
    % for i = 1 : view_num
    %     % encode direction
    %     image_direction(i, :, :) = direction_skeleton(image_project(i, :, :));
    %
    %     % encode bodyparts
    %     image_bodyparts(i, :, :) = bodyparts_skeleton(image_direction(i, :, :));
    %
    %     % encode speed
    %     image_speed(i, :, :) = speed_skeleton(image_bodyparts(i, :, :));
    % end
    
    % write image
    [pathstr,name,ext] = fileparts(filename);
    for j = 1 : view_num
        imwrite(hsv2rgb(imrotate(reshape(image_project(j,:,:, :),[256, 256, 3]), 90)), [write_dir name '_proj' int2str(j) '.png']);
    end
    
    
end